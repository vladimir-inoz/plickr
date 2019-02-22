import UIKit

class PhotosViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let dataSource = PhotoDataSource()
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
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 90.0, height: 90.0)
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.sectionInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = dataSource
        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        
        let handleResult = {
            (photosResult: PhotosResult) -> Void in
            
            switch photosResult {
            case let .success(photos):
                print("Successfully downloaded \(photos.count) photos")
                self.dataSource.photos = photos
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
                self.dataSource.photos.removeAll()
            }
            
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
        
        switch method {
        case .interestingPhotos:
            store.fetchInterestingPhotos(completion: handleResult)
        case .recentPhotos:
            store.fetchRecentPhotos(completion: handleResult)
        }
    }
}
