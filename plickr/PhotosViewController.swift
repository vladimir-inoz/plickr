import UIKit

class PhotosViewController: UIViewController {
    var imageView: UIImageView!
    var store: PhotoStore!
    
    func setup() {
        imageView = UIImageView()
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        store.fetchRecentPhotos {
            (photosResult) -> Void in
            
            switch photosResult {
            case let .success(photos):
                print("Successfully downloaded \(photos.count) photos")
                if let firstPhoto = photos.first {
                    self.updateImageView(for: firstPhoto)
                }
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
            }
        }
    }
    
    func updateImageView(for photo: Photo) {
        store.fetchImage(for: photo) {
            (imageResult) -> Void in
            
            switch imageResult {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error downloading image: \(error.localizedDescription)")
            }
        }
    }
}
