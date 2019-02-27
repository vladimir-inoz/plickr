import UIKit
import UIComponents

extension UIColor {
    static func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

class TestPhotoPresenter: PhotosViewPresenterProtocol {
    /// generating dummy images filled with random coloe
    private let dummyImages: [UIImage] = {
        let range = 0...40
        let images = range.map { _ -> UIImage in
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50.0, height: 50.0))
            let image = renderer.image { (context) in
                UIColor.randomColor().setFill()
                context.fill(CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
            }
            return image
        }
        return images
    }()
    
    var photosCount: Int {
        get {
            return dummyImages.count
        }
    }
    
    func reloadPhotosFromServer() {
        //do nothing
    }
    
    func fetchImageForIndex(index: Int, completion: @escaping (Int, UIImage?) -> Void) {
        completion(index, dummyImages[index])
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let photosVC = PhotosViewController()
        let photosPresenter = TestPhotoPresenter()
        photosVC.presenter = photosPresenter
        photosVC.tabBarItem = UITabBarItem(title: "Photos", image: nil, selectedImage: nil)
        
        let imageVC = SwipeImageViewController()
        imageVC.tabBarItem = UITabBarItem(title: "SwipeImage", image: nil, selectedImage: nil)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [photosVC, imageVC]
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

