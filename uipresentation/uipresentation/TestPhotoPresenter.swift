import UIKit
import UIComponents

extension UIColor {
    static func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

class TestPhotoPresenter: PhotosViewPresenterProtocol {
    /// generating dummy images filled with random coloe
    private let dummyImages: [UIImage] = {
        let range = 0...40
        let images = range.map { _ -> UIImage in
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50.0, height: 50.0))
            let image = renderer.image { (context) in
                UIColor.randomColor().setFill()
                context.fill(CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
            }
            return image
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
}

