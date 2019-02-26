import UIKit
import FetchPhotos

class PhotosViewController: UIViewController, UICollectionViewDelegate, PhotosViewProtocol {
    private var collectionView: UICollectionView!
    private let dataSource = PhotoDataSource()
    var presenter: PhotosViewPresenterProtocol! = nil {
        didSet {
            dataSource.presenter = presenter
        }
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
        collectionView.delegate = self
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
        presenter.reloadPhotosFromServer()
    }
    
    //MARK: - Photos View protocol
    
    func reload() {
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    
    //MARK: - Collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.fetchImageForIndex(index: indexPath.row) {
            (indexRow, photoResult) in
            let indexPath = IndexPath(item: indexRow, section: 0)
            if case let .success(image) = photoResult,
                let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell {
                cell.update(with: image)
            }
        }
    }
}
