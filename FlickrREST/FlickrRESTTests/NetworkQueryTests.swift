import XCTest
@testable import FetchPhotos

class NetworkQueryTests: XCTestCase {

    private let dummyImageData: Data = {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let jpegData = image!.jpegData(compressionQuality: 0.8)!
        return jpegData
    }()

    private let dummyPhoto = Photo(title: "asdfas",
                                   photoID: "asdfasdf",
                                   remoteURL: URL(string: "https://www.get.com")!,
                                   dateTaken: Date())

    /// Testing case when fetching image is successful
    func testSuccessFetch() {
        //Mocking http client
        class MockHTTPClient: HTTPClientProtocol {
            let data: Data
            init(data: Data) {
                self.data = data
            }
            func getData(with: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
                completionHandler(data, nil, nil)
            }
        }

        let store = PhotoStore()
        store.client = MockHTTPClient(data: dummyImageData)
        let expectation = XCTestExpectation(description: "Waiting for http response")
        var fetchResult: ImageResult?

        store.fetchImage(for: dummyPhoto) {
            fetchResult = $0
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)

        XCTAssertNotNil(fetchResult)
        if let validResult = fetchResult {
            if case .failure = validResult {
                //valid result should be .success
                XCTFail("Error when loading image")
            }
        }
    }

    /// Testing case when server did not respond at all
    func testFailWithTimeout() {
        //Mocking http client that does not respond
        class MockHTTPClient: HTTPClientProtocol {
            func getData(with: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
            }
        }

        let store = PhotoStore()
        store.client = MockHTTPClient()
        let expectation = XCTestExpectation(description: "Waiting for http response")
        expectation.isInverted = true

        store.fetchImage(for: dummyPhoto) { _ in
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    /// Testing case when server responded with error
    func testFail() {
        //Mocking http client that does not respond
        class MockHTTPClient: HTTPClientProtocol {
            func getData(with: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
                completionHandler(nil, nil, URLError(.notConnectedToInternet))
            }
        }

        let store = PhotoStore()
        store.client = MockHTTPClient()
        let expectation = XCTestExpectation(description: "Waiting for http response")
        var fetchResult: ImageResult?

        store.fetchImage(for: dummyPhoto) {
            fetchResult = $0
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)

        XCTAssertNotNil(fetchResult)
        if let validResult = fetchResult {
            if case .success = validResult {
                XCTFail("Fetch result should be .failure")
            }
        }
    }
}
