import UIKit

public enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

public enum PhotoError: Error {
    case imageCreationError
}

public enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

/// `PhotoStore` class is responsible for downloading images from flickr with URLSession using `FlickrAPI` struct
public class PhotoStore {
    public init() {}
    private let imageStore = ImageStore()
    internal var client: HTTPClientProtocol = HTTPClient()

    /// Fetch image from local cache (if it already exists)
    /// or download it via network
    ///
    /// - Parameters:
    ///   - photo: photo object
    ///   - completion: completion closure
    public func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
        //trying to fetch image from local cache
        if let image = imageStore.image(forKey: photo.photoID) {
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            return
        }
        //not found image in local cache, download it
        let request = URLRequest(url: photo.remoteURL)
        client.getData(with: request) { (data, _, error) -> Void in
            let result = self.dataToImage(data: data, error: error)

            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photo.photoID)
            }

            OperationQueue.main.addOperation {
                completion(result)
            }
        }
    }

    private func dataToImage(data: Data?, error: Error?) -> ImageResult {
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {
                if data == nil {
                    return .failure(error!)
                } else {
                    return .failure(PhotoError.imageCreationError)
                }
        }

        return .success(image)
    }

    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }

        return FlickrAPI.photos(fromJSON: jsonData)
    }

    public func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {
        fetch(url: FlickrAPI.interestingPhotosURL, completion: completion)
    }

    public func fetchRecentPhotos(completion: @escaping (PhotosResult) -> Void) {
        fetch(url: FlickrAPI.recentPhotosURL, completion: completion)
    }

    private func fetch(url: URL, completion: @escaping (PhotosResult) -> Void) {
        let request = URLRequest(url: url)
        client.getData(with: request) { (data, _, error) -> Void in

            let result = self.processPhotosRequest(data: data, error: error)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
