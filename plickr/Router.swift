import UIKit
import UIComponents
import FlickrREST

protocol DetailedPhotoRoute {
    func openDetailedPhoto(photoStore: PhotoStore, method: FlickrAPI.Method)
}

extension DetailedPhotoRoute where Self: UIViewController {
    func openDetailedPhoto(photoStore: PhotoStore, method: FlickrAPI.Method) {
        let detailedViewController = PhotosViewController()
        detailedViewController.layoutType = .page
        let presenter = PhotosViewPresenter(view: detailedViewController, store: photoStore, method: method)
        detailedViewController.presenter = presenter

        if let navigationController = self.navigationController {
            navigationController.pushViewController(detailedViewController, animated: true)
        } else {
            present(detailedViewController, animated: true)
        }
    }
}

extension PhotosViewController: DetailedPhotoRoute {}
