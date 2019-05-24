import UIKit
import UIComponents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        let photosVC = PhotosViewController()
        let photosPresenter = TestPhotoPresenter()
        photosVC.presenter = photosPresenter
        photosVC.tabBarItem = UITabBarItem(title: "Photos", image: nil, selectedImage: nil)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [photosVC]
        window?.rootViewController = tabBarController
        return true
    }

}
