import UIComponents

class SwipeImagePresenter: SwipeImageViewPresenterProtocol {
    var currentImageIndex: Int = 0 {
        didSet {
            if currentImageIndex < 0 {
                currentImageIndex = 0
            }
            if currentImageIndex > photosViewPresenter.photosCount - 1 {
                currentImageIndex = photosViewPresenter.photosCount - 1
            }
        }
    }
    var photosViewPresenter: PhotosViewPresenterProtocol!
    
    func getNextImage(completion: @escaping (UIImage?) -> Void) {
        guard currentImageIndex < photosViewPresenter.photosCount - 1 else {
            completion(nil)
            return
        }
        photosViewPresenter.fetchImageForIndex(index: currentImageIndex + 1) {
            index, image in
            completion(image)
        }
    }
    
    func getCurrentImage(completion: @escaping (UIImage?) -> Void) {
        photosViewPresenter.fetchImageForIndex(index: currentImageIndex) {
            index, image in
            completion(image)
        }
    }
    
    func getPreviousImage(completion: @escaping (UIImage?) -> Void) {
        guard currentImageIndex > 0 else {
            completion(nil)
            return
        }
        photosViewPresenter.fetchImageForIndex(index: currentImageIndex - 1) {
            index, image in
            completion(image)
        }
    }
    
    func hasNextImage() -> Bool {
        if currentImageIndex < photosViewPresenter.photosCount - 1 {
            return true
        }
        
        return false
    }
    
    func hasPreviousImage() -> Bool {
        if currentImageIndex > 0 {
            return true
        }
        
        return false
    }
    
    func switchToNextImage() {
        currentImageIndex = currentImageIndex + 1
    }
    
    func switchToPreviousImage() {
        currentImageIndex = currentImageIndex - 1
    }
    
}
