import UIKit

class MainTabBarControllerDelegate: NSObject, UITabBarControllerDelegate {
    var router: Router?
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        router?.currentViewController = viewController
    }
}
