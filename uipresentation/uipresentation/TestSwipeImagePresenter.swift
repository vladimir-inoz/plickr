import UIComponents

class TestSwipeImagePresenter: SwipeImageViewPresenterProtocol {
    func nextImage() -> UIImage? {
        return nil
    }
    
    func currentImage() -> UIImage? {
        return Utils.generateImage(withSize: CGSize(width: 50.0, height: 50.0))
    }
    
    func previousImage() -> UIImage? {
        return nil
    }
    
    func hasNextImage() -> Bool {
        return false
    }
    
    func hasPreviousImage() -> Bool {
        return false
    }
    
    
}
