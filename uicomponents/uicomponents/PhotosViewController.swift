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

public class PhotosViewController: UIViewController, PhotosViewProtocol {
    public enum LayoutType {
        case grid, page
    }
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: gridLayout)
        view.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        view.dataSource = dataSource
        view.delegate = self
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private let dataSource = PhotoDataSource()
    
    private let gridLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 90.0, height: 90.0)
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        layout.sectionInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        return layout
    }()
    private let pageLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let size = UIScreen.main.bounds.size.width
        layout.itemSize = CGSize(width: size, height: size)
        layout.estimatedItemSize = layout.itemSize
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        return layout
    }()

    public var presenter: PhotosViewPresenterProtocol! = nil {
        didSet {
            dataSource.presenter = presenter
        }
    }
    
    public var layoutType: LayoutType = .grid {
        didSet {
            switch layoutType {
            case .grid:
                collectionView.isPagingEnabled = false
                collectionView.collectionViewLayout = gridLayout
            case .page:
                collectionView.isPagingEnabled = true
                collectionView.clipsToBounds = false
                collectionView.collectionViewLayout = pageLayout
            }
        }
    }

    func setup() {
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

    // MARK: - Photos View protocol

    public func reload() {
        collectionView.reloadSections(IndexSet(integer: 0))
    }
}

extension PhotosViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.fetchImageForIndex(index: indexPath.row) {
            (_, photo) in
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
