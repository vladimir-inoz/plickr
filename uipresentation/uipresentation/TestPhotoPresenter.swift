import UIKit
import UIComponents

class TestPhotoPresenter: PhotosViewPresenterProtocol {
    
    /// generating dummy images filled with random coloe
    private let dummyImages: [UIImage] = {
        let range = 0...40
        let images = range.map { _ -> UIImage in
            return Utils.generateImage(withSize: CGSize(width: 50.0, height: 50.0))
        }
        return images
    }()
    
    var photosCount: Int {
        get {
            return dummyImages.count
        }
    }
    
    func reloadPhotosFromServer() {
        //do nothing
    }
    
    func fetchImageForIndex(index: Int, completion: @escaping (Int, UIImage?) -> Void) {
        completion(index, dummyImages[index])
    }
    
    func userSelectedIndex(index: Int) {
        print("User selected index: \(index)")
    }
}

