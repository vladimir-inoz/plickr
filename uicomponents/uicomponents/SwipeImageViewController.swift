import UIKit

public class SwipeImageViewController: UIViewController {
    private var imageView: UIImageView!
    
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
