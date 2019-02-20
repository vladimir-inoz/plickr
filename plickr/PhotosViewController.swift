import UIKit

class PhotosViewController: UIViewController {
    var imageView: UIImageView!
    private let store: PhotoStore
    private let method: Method
    
    init(method: Method, store: PhotoStore) {
        self.method = method
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.method = .interestingPhotos
        self.store = PhotoStore()
        super.init(coder: aDecoder)
    }
    
    func setup() {
        imageView = UIImageView()
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        
        let tabTitle: String
        switch method {
        case .interestingPhotos:
            tabTitle = "Interesting"
        case .recentPhotos:
            tabTitle = "Recent"
        }
        tabBarItem = UITabBarItem(title: tabTitle, image: nil, selectedImage: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        
        let handleResult = {
            (photosResult: PhotosResult) -> Void in
            
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
        
        switch method {
        case .interestingPhotos:
            store.fetchInterestingPhotos(completion: handleResult)
        case .recentPhotos:
            store.fetchRecentPhotos(completion: handleResult)
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
