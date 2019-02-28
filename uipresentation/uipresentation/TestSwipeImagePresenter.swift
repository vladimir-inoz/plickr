import UIComponents

class TestSwipeImagePresenter: SwipeImageViewPresenterProtocol {
    private let maxIndex = 15
    private let minIndex = 5
    private var currentIndex = 10
    
    func nextImage() -> UIImage? {
        return Utils.generateImage(withSize: CGSize(width: 50.0, height: 50.0))
    }
    
    func currentImage() -> UIImage? {
        return Utils.generateImage(withSize: CGSize(width: 50.0, height: 50.0))
    }
    
    func previousImage() -> UIImage? {
        return Utils.generateImage(withSize: CGSize(width: 50.0, height: 50.0))
    }
    
    func hasNextImage() -> Bool {
        if currentIndex < maxIndex {
            currentIndex = currentIndex + 1
            return true
        }
        
        return false
    }
    
    func hasPreviousImage() -> Bool {
        if currentIndex > minIndex {
            currentIndex = currentIndex - 1
            return true
        }
        
        return false
    }
    
    
}
