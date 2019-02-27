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
    
    private func setup() {
        imageView = UIImageView()
        imageView.image = presenter.currentImage()
        imageView.isUserInteractionEnabled = true
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        imageView.addGestureRecognizer(panGestureRecognizer)
        
        setupCoordinators()
    }
    
    private func setupCoordinators() {
        let leftAnimation = { [unowned self] in
            self.imageView.frame = self.imageView.frame.offsetBy(dx: -self.view.bounds.width, dy: 0.0)
        }
        let rightAnimation = { [unowned self] in
            self.imageView.frame = self.imageView.frame.offsetBy(dx: self.view.bounds.width, dy: 0.0)
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
    
    func coordinator(_ coordinator: SwipeImageAnimationCoordinator, finishedTransitionWithDirection: SwipeImageAnimationCoordinator.AnimationDirection) {
        
    }
}
