import UIKit
import UIComponents
import FlickrREST

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let photoStore = PhotoStore()
    private lazy var interestingPhotosController: UIViewController = {
        let controller = PhotosViewController()
        let presenter = PhotosViewPresenter(view: controller,
                                            store: photoStore,
                                            method: .interestingPhotos)
        controller.presenter = presenter
        controller.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        controller.navigationItem.title = "Interesting"
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.view.backgroundColor = UIColor.white
        return navigationController
    }()

    private lazy var recentPhotosController: UIViewController = {
        let controller = PhotosViewController()
        let presenter = PhotosViewPresenter(view: controller,
                                            store: photoStore,
                                            method: .recentPhotos)
        controller.presenter = presenter
        controller.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
        controller.navigationItem.title = "Recent"
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.view.backgroundColor = UIColor.white
        return navigationController
    }()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [interestingPhotosController,
                                            recentPhotosController]

        window?.rootViewController = tabBarController
        return true
    }

}
