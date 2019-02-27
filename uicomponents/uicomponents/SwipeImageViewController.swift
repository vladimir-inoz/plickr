import UIKit

public protocol SwipeImageViewPresenterProtocol: class {
    func nextImage() -> UIImage?
    func previousImage() -> UIImage?
    func hasNextImage() -> Bool
    func hasPreviousImage() -> Bool
}

public protocol SwipeImageView: class {
    
}

public class SwipeImageViewController: UIViewController {
    private var previousImageView: UIImageView!
    private var imageView: UIImageView!
    private var nextImageView: UIImageView!
    
    private func setup() {
        imageView = UIImageView()
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}
