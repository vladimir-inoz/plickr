import UIKit

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum PhotoError: Error {
    case imageCreationError
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {
    private let session: URLSession = {
       let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
        let request = URLRequest(url: photo.remoteURL)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            let result = self.dataToImage(data: data, error: error)
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
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
    
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {
        fetch(url: FlickrAPI.interestingPhotosURL, completion: completion)
    }
    
    func fetchRecentPhotos(completion: @escaping (PhotosResult) -> Void) {
        fetch(url: FlickrAPI.recentPhotosURL, completion: completion)
    }
    
    private func fetch(url: URL, completion: @escaping (PhotosResult) -> Void) {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processPhotosRequest(data: data, error: error)
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
    }
}
