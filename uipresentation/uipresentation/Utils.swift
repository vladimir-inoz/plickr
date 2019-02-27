import UIKit

extension UIColor {
    static func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

struct Utils {
    private init() {}
    
    static func generateImage(withSize size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { (context) in
            UIColor.randomColor().setFill()
            context.fill(CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        }
        return image
    }
}
