import UIKit
import UIComponents

class Router {
    var currentViewController: UIViewController? = nil
    
    func userSelectedIndex(in presenter: PhotosViewPresenterProtocol, index: Int) {
        guard let current = currentViewController else {return}
        let swipeViewController = SwipeImageViewController()
        let swipePresenter = SwipeImagePresenter()
        swipePresenter.photosViewPresenter = presenter
        swipePresenter.currentImageIndex = index
        swipeViewController.presenter = swipePresenter
        current.navigationController?.pushViewController(swipeViewController, animated: true)
    }
}
