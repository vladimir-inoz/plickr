import UIKit


protocol SwipeImageAnimationCoordinatorDelegate {
    func coordinator(_ coordinator: SwipeImageAnimationCoordinator, beganTransitionWithDirection: SwipeImageAnimationCoordinator.AnimationDirection)
    func coordinator(_ coordinator: SwipeImageAnimationCoordinator, finishedTransitionWithDirection: SwipeImageAnimationCoordinator.AnimationDirection)
}
/*
 This class receives events from pan and touch gesture recognizers
 And controls corresponding UIViewPropertyAnimator
 You should provide timing parameters
 */
final class SwipeImageAnimationCoordinator {
    //Struct that stores parameter of one animation
    struct AnimationParameters {
        let leftAnimation: () -> Void
        let rightAnimation: () -> Void
        let timingParameters: UITimingCurveProvider
    }
    //our controlled animators
    private var animators = [UIViewPropertyAnimator]()
    //progress of animation when user 'captured' it with pan gesture
    private var progressWhenInterrupted = [CGFloat]()
    //width of the screen
    private let width: CGFloat
    //initial animation direction
    enum AnimationDirection {
        case left, right, undefined
        init(fromVelocity velocity: CGPoint) {
            self = velocity.x > 0 ? .right : .left
        }
    }
    private var initialAnimationDirection: AnimationDirection = .undefined
    //stored animation parameters
    private let animationParameters: [AnimationParameters]
    //shared animation duration
    private let duration: TimeInterval
    //delegate for handling events
    public var delegate: SwipeImageAnimationCoordinatorDelegate?
    
    init(withViewWidth width: CGFloat, duration: TimeInterval, animationParameters: [AnimationParameters]) {
        self.width = width
        self.animationParameters = animationParameters
        self.duration = duration
    }
    
    //Initialize animators to transition to needed state
    private func initializeAnimators(withDirection direction: AnimationDirection) {
        //initialize animators
        animators = animationParameters.map {
            var animatorFunction: () -> Void
            switch direction {
            case .left:
                animatorFunction = $0.leftAnimation
            case .right:
                animatorFunction = $0.rightAnimation
            case .undefined:
                fatalError("Undefined animation direction")
            }
            let animator = UIViewPropertyAnimator(duration: duration, timingParameters: $0.timingParameters)
            animator.scrubsLinearly = true
            animator.addAnimations(animatorFunction)
            return animator
        }
        //add completion to only first animator
        animators.first?.addCompletion {
            [unowned self] (position) -> Void in
            //calling delegate
            self.delegate?.coordinator(self, finishedTransitionWithDirection: self.initialAnimationDirection)
            //nulling directions
            self.initialAnimationDirection = .undefined
            //erasing progress when interrupted
            self.progressWhenInterrupted = [CGFloat]()
            //nulling animators
            self.animators.dropFirst().forEach {
                $0.stopAnimation(false)
                $0.finishAnimation(at: position)
            }
            self.animators.removeAll()
        }
        
        //start animation
        animators.forEach { $0.startAnimation() }
    }
    
    func startInteractiveTransition(with direction: AnimationDirection, duration: TimeInterval) {
        if animators.isEmpty {
            initializeAnimators(withDirection: direction)
        }
        animators.forEach {$0.pauseAnimation()}
        progressWhenInterrupted = animators.map{return $0.fractionComplete}
    }
    
    //update animation when user pans
    func updateInteractiveTransition(translation: CGPoint, velocity: CGPoint) {
        var fractionComplete: CGFloat = 0.0
        
        switch initialAnimationDirection {
        case .left:
            fractionComplete = -translation.x / width
        case .right:
            fractionComplete = translation.x / width
        case .undefined:
            break
        }
        
        for (index, animator) in animators.enumerated() {
            //substracting the fraction if the animator is reversed
            if animator.isReversed {fractionComplete *= -1}
            animator.fractionComplete = fractionComplete + progressWhenInterrupted[index]
        }
    }
    
    //finish animation when user finished pan
    func continueInteractiveTransition(translation: CGPoint, velocity: CGPoint) {
        //gesture is considered incomplete if user starts swiping up and detail
        //view is moved less than double height of header
        var gestureIsIncomplete: Bool = false
        if abs(translation.x) < 50.0 {
            gestureIsIncomplete = true
        }
        
        if velocity.x == 0 {
            //no explicit velocity, just continue animations
            animators.forEach({$0.continueAnimation(withTimingParameters: nil, durationFactor: 0)})
            return
        }
        
        for (index, animator) in animators.enumerated() {
            var timingParameters: UITimingCurveProvider!
            func switchAnimator() {
                animator.isReversed = !animator.isReversed
                animator.continueAnimation(withTimingParameters: timingParameters, durationFactor: 0)
            }
            
            switch initialAnimationDirection {
            case .left:
                if velocity.x > 0 && !animator.isReversed {switchAnimator()}
                if velocity.x < 0 && animator.isReversed {switchAnimator()}
                if gestureIsIncomplete {switchAnimator()}
            case .right:
                if velocity.x > 0 && animator.isReversed {switchAnimator()}
                if velocity.x < 0 && !animator.isReversed {switchAnimator()}
            default:
                fatalError("There should be initial direction in continueInteractiveTransition!")
            }
            //deciding which timing parameters to use
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    //MARK: - Gesture recognizers handlers
    
    func handlePan(gestureState: UIGestureRecognizer.State, translation: CGPoint, velocity: CGPoint) {
        switch gestureState {
        case .began:
            initialAnimationDirection = AnimationDirection(fromVelocity: velocity)
            delegate?.coordinator(self, beganTransitionWithDirection: initialAnimationDirection)
            startInteractiveTransition(with: initialAnimationDirection, duration: 1.0)
        case .changed:
            updateInteractiveTransition(translation: translation, velocity: velocity)
        case .ended, .cancelled:
            continueInteractiveTransition(translation: translation, velocity: velocity)
        default:
            break
        }
    }
}

