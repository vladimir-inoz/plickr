import UIKit

public protocol SwipeImageViewPresenterProtocol: class {
    func nextImage() -> UIImage?
    func currentImage() -> UIImage?
    func previousImage() -> UIImage?
    func hasNextImage() -> Bool
    func hasPreviousImage() -> Bool
}

public protocol SwipeImageView: class {
    
}

public class SwipeImageViewController: UIViewController, SwipeImageAnimationCoordinatorDelegate {
    
    private var previousImageView: UIImageView!
    private var imageView: UIImageView!
    private var nextImageView: UIImageView!
    private var coordinator: SwipeImageAnimationCoordinator!
    public var presenter: SwipeImageViewPresenterProtocol!
    
    private func rearrageImageViews() {
        imageView.frame = view.bounds
        previousImageView.frame = imageView.frame.offsetBy(dx: -view.bounds.width, dy: 0.0)
        nextImageView.frame = imageView.frame.offsetBy(dx: view.bounds.width, dy: 0.0)
    }
    
    private func setup() {
        imageView = UIImageView()
        imageView.image = presenter.currentImage()
        imageView.tag = 0
        imageView.isUserInteractionEnabled = true
        view.addSubview(imageView)
        imageView.frame = view.bounds
        
        previousImageView = UIImageView()
        if presenter.hasPreviousImage() {
            previousImageView.image = presenter.previousImage()
        }
        previousImageView.tag = 1
        view.addSubview(previousImageView)
        previousImageView.frame = imageView.frame.offsetBy(dx: -view.bounds.width, dy: 0.0)
        
        nextImageView = UIImageView()
        if presenter.hasNextImage() {
            nextImageView.image = presenter.nextImage()
        }
        previousImageView.tag = 2
        view.addSubview(nextImageView)
        nextImageView.frame = imageView.frame.offsetBy(dx: view.bounds.width, dy: 0.0)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
        
        setupCoordinators()
    }
    
    private func setupCoordinators() {
        let leftAnimation = { [unowned self] in
            self.imageView.frame = self.imageView.frame.offsetBy(dx: -self.view.bounds.width, dy: 0.0)
            self.previousImageView.frame = self.previousImageView.frame.offsetBy(dx: -self.view.bounds.width, dy: 0.0)
            self.nextImageView.frame = self.nextImageView.frame.offsetBy(dx: -self.view.bounds.width, dy: 0.0)
        }
        let rightAnimation = { [unowned self] in
            self.imageView.frame = self.imageView.frame.offsetBy(dx: self.view.bounds.width, dy: 0.0)
            self.previousImageView.frame = self.previousImageView.frame.offsetBy(dx: self.view.bounds.width, dy: 0.0)
            self.nextImageView.frame = self.nextImageView.frame.offsetBy(dx: self.view.bounds.width, dy: 0.0)
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
    
    func coordinator(_ coordinator: SwipeImageAnimationCoordinator, beganTransitionWithDirection: SwipeImageAnimationCoordinator.AnimationDirection) {
        
    }
    
    func coordinator(_ coordinator: SwipeImageAnimationCoordinator, finishedTransitionWithDirection direction: SwipeImageAnimationCoordinator.AnimationDirection) {
        let newCurrent: UIImageView
        let newPrev: UIImageView
        let newNext: UIImageView
        //Depending on direction we rearrange image view and set corrent references to them
        switch direction {
        case .left:
            newCurrent = previousImageView
            newNext = imageView
            newPrev = nextImageView
            
            imageView = newCurrent
            nextImageView = newNext
            previousImageView = newPrev
            
            previousImageView.image = presenter.previousImage()
        case .right:
            newCurrent = nextImageView
            newNext = previousImageView
            newPrev = imageView
            
            imageView = newCurrent
            nextImageView = newNext
            previousImageView = newPrev
            
            nextImageView.image = presenter.nextImage()
            break
        case .undefined:
            break
        }
        
        rearrageImageViews()
    }
}
