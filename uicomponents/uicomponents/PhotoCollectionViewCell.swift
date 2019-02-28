import UIKit

/// A collection view cell class that simply displays an image if it exists
/// or a spinner if image does not exist
class PhotoCollectionViewCell: UICollectionViewCell {
    var imageActivityView: ImageActivityView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageActivityView = ImageActivityView(frame: CGRect.zero)
        addSubview(imageActivityView)
        //view fills superview
        imageActivityView.translatesAutoresizingMaskIntoConstraints = false
        imageActivityView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageActivityView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageActivityView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageActivityView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        //show up spinner
        imageActivityView.setImage(image: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageActivityView.setImage(image: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageActivityView.setImage(image: nil)
    }
    
    func setImage(image: UIImage?) {
        imageActivityView.setImage(image: image)
    }
}
