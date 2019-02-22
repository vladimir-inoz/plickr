import Foundation

public class Photo {
    public let title: String
    public let remoteURL: URL
    public let photoID: String
    public let dateTaken: Date
    
    init(title: String, photoID: String, remoteURL: URL, dateTaken: Date) {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}
