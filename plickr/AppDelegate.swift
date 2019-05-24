import UIKit
import UIComponents
import FlickrREST

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let router = Router()
    private let photoStore = PhotoStore()
    private lazy var interestingPhotosController: UIViewController = {
        let controller = PhotosViewController()
        let presenter = PhotosViewPresenter(view: controller,
                                            store: photoStore,
                                            method: .interestingPhotos)
        presenter.router = router
        controller.presenter = presenter
        controller.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        controller.navigationItem.title = "Interesting"
        return UINavigationController(rootViewController: controller)
    }()

    private lazy var recentPhotosController: UIViewController = {
        let controller = PhotosViewController()
        let presenter = PhotosViewPresenter(view: controller,
                                            store: photoStore,
                                            method: .recentPhotos)
        controller.presenter = presenter
        presenter.router = router
        controller.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
        controller.navigationItem.title = "Recent"
        return UINavigationController(rootViewController: controller)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [interestingPhotosController,
                                            recentPhotosController]

        window?.rootViewController = tabBarController
        return true
    }

}
