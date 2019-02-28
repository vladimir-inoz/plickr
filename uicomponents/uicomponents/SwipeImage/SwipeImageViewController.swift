import UIKit

public protocol SwipeImageViewPresenterProtocol: class {
    func getNextImage(completion: @escaping (UIImage?) -> Void)
    func getCurrentImage(completion: @escaping (UIImage?) -> Void)
    func getPreviousImage(completion: @escaping (UIImage?) -> Void)
    func switchToNextImage() -> Void
    func switchToPreviousImage() -> Void
    func hasNextImage() -> Bool
    func hasPreviousImage() -> Bool
}

public protocol SwipeImageView: class {
    
}

public class SwipeImageViewController: UIViewController, SwipeImageAnimationCoordinatorDelegate {
    
    private struct Tags {
        private init() {}
        static let previousImageViewTag = 5
        static let currentImageViewTag = 10
        static let nextImageViewTag = 15
    }
    
    /// This array contains tags of image views in order that they are arranged on screen
    /// So tagsArray[0] is previous image view, tagsArray[1] is current image view, tagsArray[2] is next image view
    private var tagsArray = [Tags.previousImageViewTag, Tags.currentImageViewTag, Tags.nextImageViewTag]
    private var coordinator: SwipeImageAnimationCoordinator!
    public var presenter: SwipeImageViewPresenterProtocol!
    
    private func switchTagsArray(direction: SwipeImageAnimationCoordinator.AnimationDirection) {
        switch direction {
        case .left:
            let first = tagsArray.first!
            tagsArray[0] = tagsArray[1]
            tagsArray[1] = tagsArray[2]
            tagsArray[2] = first
        case .right:
            let last = tagsArray.last!
            tagsArray[2] = tagsArray[1]
            tagsArray[1] = tagsArray[0]
            tagsArray[0] = last
        default:
            break
        }
    }
    
    private func imageViews() -> (ImageActivityView, ImageActivityView, ImageActivityView) {
        return (view.viewWithTag(tagsArray[0]) as! ImageActivityView,
        view.viewWithTag(tagsArray[1]) as! ImageActivityView,
        view.viewWithTag(tagsArray[2]) as! ImageActivityView)
    }
    
    /// Rearrange image views to represent tags array
    private func rearrageImageViews() {
        let (prev, current, next) = imageViews()
        
        current.frame = view.bounds
        prev.frame = current.frame.offsetBy(dx: -view.bounds.width, dy: 0.0)
        next.frame = current.frame.offsetBy(dx: view.bounds.width, dy: 0.0)
    }
    
    private func setup() {
        let currentImageView = ImageActivityView()
        presenter.getCurrentImage(completion: currentImageView.setImage)
        currentImageView.tag = Tags.currentImageViewTag
        currentImageView.isUserInteractionEnabled = true
        view.addSubview(currentImageView)
        currentImageView.frame = view.bounds
        
        let previousImageView = ImageActivityView()
        if presenter.hasPreviousImage() {
            presenter.getPreviousImage(completion: previousImageView.setImage)
        }
        previousImageView.tag = Tags.previousImageViewTag
        view.addSubview(previousImageView)
        previousImageView.frame = currentImageView.frame.offsetBy(dx: -view.bounds.width, dy: 0.0)
        
        let nextImageView = ImageActivityView()
        if presenter.hasNextImage() {
            presenter.getNextImage(completion: nextImageView.setImage)
        }
        nextImageView.tag = Tags.nextImageViewTag
        view.addSubview(nextImageView)
        nextImageView.frame = currentImageView.frame.offsetBy(dx: view.bounds.width, dy: 0.0)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
        
        setupCoordinators()
    }
    
    private func setupCoordinators() {
        let (prev, current, next) = imageViews()
        //in these animations we just shifting all three image views on the same offset
        let leftAnimation = { [unowned self] in
            current.frame = current.frame.offsetBy(dx: -self.view.bounds.width, dy: 0.0)
            prev.frame = prev.frame.offsetBy(dx: -self.view.bounds.width, dy: 0.0)
            next.frame = next.frame.offsetBy(dx: -self.view.bounds.width, dy: 0.0)
        }
        let rightAnimation = { [unowned self] in
            current.frame = current.frame.offsetBy(dx: self.view.bounds.width, dy: 0.0)
            prev.frame = prev.frame.offsetBy(dx: self.view.bounds.width, dy: 0.0)
            next.frame = next.frame.offsetBy(dx: self.view.bounds.width, dy: 0.0)
        }
        let easeInTimingParameters = UICubicTimingParameters(animationCurve: .easeIn)
        let parameters = SwipeImageAnimationCoordinator.AnimationParameters(leftAnimation: leftAnimation, rightAnimation: rightAnimation, timingParameters: easeInTimingParameters)
        coordinator = SwipeImageAnimationCoordinator(withViewWidth: view.bounds.width, duration: 0.5, animationParameters: [parameters])
        coordinator.delegate = self
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        coordinator.handlePan(gestureState: recognizer.state, translation: recognizer.translation(in: view), velocity: recognizer.velocity(in: view))
    }
    
    //MARK: - Animation Coordinator Delegate

    /// When we start pan gesture we pre-download corresponding image
    func coordinator(_ coordinator: SwipeImageAnimationCoordinator, beganTransitionWithDirection direction: SwipeImageAnimationCoordinator.AnimationDirection) -> Bool {
        
        let (prev, _, next) = imageViews()
        
        switch direction {
        case .left:
            if !presenter.hasNextImage() { return false }
            
            prev.setImage(image: nil)
            presenter.getNextImage(completion: prev.setImage)
            
            return true
        case .right:
            if !presenter.hasPreviousImage() { return false }
            
            next.setImage(image: nil)
            presenter.getPreviousImage(completion: next.setImage)
            
            return true
        case .undefined:
            return false
        }
    }
    
    func coordinator(_ coordinator: SwipeImageAnimationCoordinator, finishedTransitionWithDirection direction: SwipeImageAnimationCoordinator.AnimationDirection) {
        //updating index in presenter
        switch direction {
        case .left:
            presenter.switchToNextImage()
        case .right:
            presenter.switchToPreviousImage()
        default:
            break
        }
        //rearrange image views
        switchTagsArray(direction: direction)
        rearrageImageViews()
    }
}
