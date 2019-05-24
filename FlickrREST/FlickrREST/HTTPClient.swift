import Foundation

protocol HTTPClientProtocol: class {
    func getData(with: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class HTTPClient: HTTPClientProtocol {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()

    func getData(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = session.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
}
