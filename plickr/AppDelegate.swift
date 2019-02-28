import UIKit
import UIComponents
import FlickrREST

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let router = Router()
        
        let photoStore = PhotoStore()
        
        let interestingViewController = PhotosViewController()
        let interestingViewPresenter = PhotosViewPresenter(view: interestingViewController, store: photoStore, method: .interestingPhotos)
        interestingViewController.presenter = interestingViewPresenter
        interestingViewPresenter.router = router
        interestingViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        interestingViewController.navigationItem.title = "Interesting"
        
        let interestingNavigationController = UINavigationController(rootViewController: interestingViewController)
        
        router.currentViewController = interestingViewController
        
        let recentViewController = PhotosViewController()
        let recentViewPresenter = PhotosViewPresenter(view: recentViewController, store: photoStore, method: .recentPhotos)
        recentViewController.presenter = recentViewPresenter
        recentViewPresenter.router = router
        recentViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
        recentViewController.navigationItem.title = "Recent"
        
        let recentNavigationController = UINavigationController(rootViewController: recentViewController)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [interestingNavigationController, recentNavigationController]
        let delegate = MainTabBarControllerDelegate()
        delegate.router = router
        tabBarController.delegate = delegate
        window?.rootViewController = tabBarController
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

