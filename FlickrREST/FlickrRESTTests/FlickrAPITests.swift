//
//  FetchPhotosTests.swift
//  FetchPhotosTests
//
//  Created by User on 22/02/2019.
//  Copyright © 2019 test. All rights reserved.
//

import XCTest
@testable import FetchPhotos

class FlickrAPITests: XCTestCase {

    func testPhotoGenerationSuccess() {
        let jsonResponse = """
        { \"photos\": { \"page\": 1, \"pages\": \"500\", \"perpage\": 2, \"total\": \"1000\",
        \"photo\": [
        { \"id\": \"46483455004\", \"owner\": \"48332887@N04\", \"secret\": \"711cc8f485\", \"server\": \"7844\", \"farm\": 8, \"title\": \"0022658_Adm vs Innsbruck\", \"ispublic\": 1, \"isfriend\": 0, \"isfamily\": 0, \"datetaken\": \"2019-02-23 17:02:29\", \"datetakengranularity\": 0, \"datetakenunknown\": 0, \"url_h\": \"https://farm8.staticflickr.com/7844/46483455004_058cf8b6a8_h.jpg\", \"height_h\": \"1067\", \"width_h\": \"1600\" },
        { \"id\": \"47206811831\", \"owner\": \"152925019@N02\", \"secret\": \"27797abbc5\", \"server\": \"7800\", \"farm\": 8, \"title\": \"Apparel Attire\", \"ispublic\": 1, \"isfriend\": 0, \"isfamily\": 0, \"datetaken\": \"2019-02-25 02:52:51\", \"datetakengranularity\": 0,      \"datetakenunknown\": 1, \"url_h\": \"https://farm8.staticflickr.com/7800/47206811831_21d64d7686_h.jpg\", \"height_h\": \"1600\",    \"width_h\": \"1043\" }
        ] }, \"stat\": \"ok\" }
        """

        let photosResult = FlickrAPI.photos(fromJSON: jsonResponse.data(using: .utf8)!)
        if case let .success(photos) = photosResult {
            XCTAssertEqual(photos.count, 2)
            let calendar = Calendar.current
            //first photo
            var components = DateComponents()
            components.calendar = calendar
            components.year = 2019
            components.month = 2
            components.day = 23
            components.hour = 17
            components.minute = 2
            components.second = 29
            XCTAssertEqual(photos[0].dateTaken, components.date!)
            XCTAssertEqual(photos[0].photoID, "46483455004")
            XCTAssertEqual(photos[0].remoteURL.absoluteString,
                           "https://farm8.staticflickr.com/7844/46483455004_058cf8b6a8_h.jpg")
            XCTAssertEqual(photos[0].title, "0022658_Adm vs Innsbruck")
            //second photo
            components.year = 2019
            components.month = 2
            components.day = 25
            components.hour = 2
            components.minute = 52
            components.second = 51
            XCTAssertEqual(photos[1].dateTaken, components.date!)
            XCTAssertEqual(photos[1].photoID, "47206811831")
            XCTAssertEqual(photos[1].remoteURL.absoluteString,
                           "https://farm8.staticflickr.com/7800/47206811831_21d64d7686_h.jpg")
            XCTAssertEqual(photos[1].title, "Apparel Attire")
        } else {
            XCTFail("failure on parsing")
        }
    }

    /// Here we provide json data without required fields
    func testPhotoGenerationPartialFail() {
        let jsonResponse = """
        { \"photos\": { \"page\": 1, \"pages\": \"500\", \"perpage\": 2, \"total\": \"1000\",
        \"photo\": [
        { \"id\": \"46483455004\", \"owner\": \"48332887@N04\", \"secret\": \"711cc8f485\", \"server\": \"7844\", \"farm\": 8, \"title\": \"0022658_Adm vs Innsbruck\", \"ispublic\": 1, \"isfriend\": 0, \"isfamily\": 0, \"datetaken\": \"2019-02-23 17:02:29\", \"datetakengranularity\": 0, \"datetakenunknown\": 0, \"height_h\": \"1067\", \"width_h\": \"1600\" },
        { \"id\": \"47206811831\", \"owner\": \"152925019@N02\", \"secret\": \"27797abbc5\", \"server\": \"7800\", \"farm\": 8, \"ispublic\": 1, \"isfriend\": 0, \"isfamily\": 0, \"datetaken\": \"2019-02-25 02:52:51\", \"datetakengranularity\": 0,      \"datetakenunknown\": 1, \"url_h\": \"https://farm8.staticflickr.com/7800/47206811831_21d64d7686_h.jpg\", \"height_h\": \"1600\",    \"width_h\": \"1043\" }
        ] }, \"stat\": \"ok\" }
        """

        let photosResult = FlickrAPI.photos(fromJSON: jsonResponse.data(using: .utf8)!)
        if case let .failure(error) = photosResult {
            XCTAssertTrue(error is FlickrAPI.FlickrError)
            if let flickrError = error as? FlickrAPI.FlickrError {
                XCTAssertTrue(flickrError == FlickrAPI.FlickrError.invalidJSONData)
            }
        } else {
            XCTFail("Provided json response is invalid")
        }
    }

    func testPhotoGenerationFail() {
        let jsonResponse = "{}"

        let photosResult = FlickrAPI.photos(fromJSON: jsonResponse.data(using: .utf8)!)
        if case let .failure(error) = photosResult {
            XCTAssertTrue(error is FlickrAPI.FlickrError)
            if let flickrError = error as? FlickrAPI.FlickrError {
                XCTAssertTrue(flickrError == FlickrAPI.FlickrError.invalidJSONData)
            }
        } else {
            XCTFail("Provided json response is invalid")
        }
    }

}
