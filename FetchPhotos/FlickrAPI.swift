import Foundation

/// Struct responsible for creating query urls and parsing json responses
public struct FlickrAPI {
    public enum Method: String {
        case interestingPhotos = "flickr.interestingness.getList"
        case recentPhotos = "flickr.photos.getRecent"
    }
    
    public enum FlickrError: Error {
        case invalidJSONData
    }
    
    private init() {}
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    private static func flickrURL(method: Method, parameters: [String:String]?) -> URL {
        var components = URLComponents(string: baseURLString)!
        
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": Secret.APIKey
        ]
        
        components.queryItems = baseParams.map{return URLQueryItem(name: $0, value: $1)}
        
        if let additionalParameters = parameters {
            components.queryItems!.append(contentsOf: additionalParameters.map{return URLQueryItem(name: $0, value: $1)})
        }
        
        return components.url!
    }
    
    private static func photo(fromJSON json: [String : Any]) -> Photo? {
        guard
            let photoID = json["id"] as? String,
            let title = json["title"] as? String,
            let dateString = json["datetaken"] as? String,
            let photoURLString = json["url_h"] as? String,
            let url = URL(string: photoURLString),
            let dateTaken = dateFormatter.date(from: dateString) else {
                return nil
        }
        
        return Photo(title: title, photoID: photoID, remoteURL: url, dateTaken: dateTaken)
    }
    
    static var interestingPhotosURL: URL {
        return flickrURL(method: .interestingPhotos, parameters: ["extras": "url_h,date_taken"])
    }
    
    static var recentPhotosURL: URL {
        return flickrURL(method: .recentPhotos, parameters: ["extras": "url_h,date_taken"])
    }
    
    public static func photos(fromJSON data: Data) -> PhotosResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let photos = jsonDictionary["photos"] as? [String:Any],
                let photosArray = photos["photo"] as? [[String:Any]] else {
                    //JSON structure invalid
                    return .failure(FlickrError.invalidJSONData)
            }
            let finalPhotos = photosArray.compactMap{return photo(fromJSON: $0)}
            if finalPhotos.isEmpty && !photosArray.isEmpty {
                //couldn't parse data
                return .failure(FlickrError.invalidJSONData)
            }
            return .success(finalPhotos)
        } catch let error {
            return .failure(error)
        }
    }
}
