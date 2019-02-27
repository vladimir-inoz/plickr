import Foundation
import FetchPhotos

class PhotosViewPresenter: PhotosViewPresenterProtocol {
    private let store: PhotoStore
    private let method: FlickrAPI.Method
    private var photos = [Photo]()
    private unowned let view: PhotosViewProtocol
    
    init(view: PhotosViewProtocol, store: PhotoStore, method: FlickrAPI.Method) {
        self.view = view
        self.store = store
        self.method = method
    }
    
    private func reloadModel(photosResult: PhotosResult) {
        switch photosResult {
        case let .success(photos):
            print("Successfully downloaded \(photos.count) photos")
            self.photos = photos
        case let .failure(error):
            print("Error fetching interesting photos: \(error)")
            self.photos.removeAll()
        }
        
        self.view.reload()
    }
    
    //MARK: - Photos View Presenter procotol
    
    func reloadPhotosFromServer() {
        switch method {
        case .interestingPhotos:
            store.fetchInterestingPhotos(completion: reloadModel)
        case .recentPhotos:
            store.fetchRecentPhotos(completion: reloadModel)
        }
    }
    
    var photosCount: Int {
        get {
            return photos.count
        }
    }
    
    func fetchImageForIndex(index: Int, completion: @escaping (Int, ImageResult) -> Void) {
        let photo = photos[index]
        store.fetchImage(for: photo) {
            imageResult in
            
            guard let actualPhotoIndex = self.photos.lastIndex(where: {return $0 == photo}) else {
                return
            }
            
            completion(actualPhotoIndex, imageResult)
        }
    }
}
