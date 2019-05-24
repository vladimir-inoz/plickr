import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource {
    var presenter: PhotosViewPresenterProtocol! = nil

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.photosCount
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                            for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }

        return cell
    }
}
