import UIComponents

class TestSwipeImagePresenter: SwipeImageViewPresenterProtocol {
    private let maxIndex = 15
    private let minIndex = 5
    private var currentIndex = 10
    
    func getNextImage(completion: @escaping (UIImage?) -> Void) {
        let delayTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            completion(Utils.generateImage(withSize: CGSize(width: 50.0, height: 50.0)))
        }
    }
    
    func getCurrentImage(completion: @escaping (UIImage?) -> Void) {
        let delayTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            completion(Utils.generateImage(withSize: CGSize(width: 50.0, height: 50.0)))
        }
    }
    
    func getPreviousImage(completion: @escaping (UIImage?) -> Void) {
        let delayTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            completion(Utils.generateImage(withSize: CGSize(width: 50.0, height: 50.0)))
        }
    }
    
    func hasNextImage() -> Bool {
        if currentIndex < maxIndex {
            return true
        }
        
        return false
    }
    
    func hasPreviousImage() -> Bool {
        if currentIndex > minIndex {
            return true
        }
        
        return false
    }
    
    func switchToNextImage() {
        currentIndex = currentIndex + 1
    }
    
    func switchToPreviousImage() {
        currentIndex = currentIndex - 1
    }
    
    
}
