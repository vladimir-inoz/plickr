import UIKit

public protocol PhotosViewPresenterProtocol: class {
    var photosCount: Int {get}
    func reloadPhotosFromServer()
    /// Asyncronously fetch image for index
    ///
    /// - Parameters:
    ///   - index: index of photo
    ///   - completion: new index of photo and photo result are returned in completion
    func fetchImageForIndex(index: Int, completion: @escaping (Int, UIImage?) -> Void)
    /// User selected any cell
    ///
    /// - Parameter index: index of cell
    func userSelectedIndex(index: Int)
}

public protocol PhotosViewProtocol: class {
    /// Reload corresponding view
    func reload()
}

public class PhotosViewController: UIViewController, UICollectionViewDelegate, PhotosViewProtocol {
    private var collectionView: UICollectionView!
    private let dataSource = PhotoDataSource()
    public var presenter: PhotosViewPresenterProtocol! = nil {
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
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.reloadPhotosFromServer()
    }
    
    //MARK: - Photos View protocol
    
    public func reload() {
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    
    //MARK: - Collection view delegate

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.fetchImageForIndex(index: indexPath.row) {
            (indexRow, photo) in
            if let photoCell = cell as? PhotoCollectionViewCell {
                photoCell.setImage(image: photo)
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        presenter.userSelectedIndex(index: indexPath.row)
        return true
    }
}
