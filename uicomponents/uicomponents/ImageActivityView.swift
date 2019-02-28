import UIKit

class ImageActivityView: UIView {
    var imageView: UIImageView!
    var spinner: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(image: nil)
        imageView.contentMode = .scaleAspectFit
        spinner = UIActivityIndicatorView(style: .whiteLarge)
        addSubview(imageView)
        addSubview(spinner)
        //spinner is centered at view
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        //image view fills view
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        //show up spinner
        setImage(image: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setImage(image: nil)
    }
    
    func setImage(image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
}
