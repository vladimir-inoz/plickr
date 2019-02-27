import UIComponents

class TestSwipeImagePresenter: SwipeImageViewPresenterProtocol {
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
        return true
    }
    
    func hasPreviousImage() -> Bool {
        return true
    }
    
    
}
