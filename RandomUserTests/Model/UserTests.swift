//
//  UserTests.swift
//  RandomUserTests
//
//  Created by Mateusz Matoszko on 25/12/2018.
//  Copyright © 2018 Mateusz Matoszko. All rights reserved.
//

import XCTest
@testable import RandomUser

class UserTests: XCTestCase {

    func testParsingSingleUser() throws {
        let user = try usersFrom(json: singleUserResults).results.first
        XCTAssertNotNil(user)
        XCTAssertEqual("jennifer.white@example.com", user?.email)
        XCTAssertEqual("7fa847c6-cc2a-47de-bd61-b93cd9bba351", user?.login.uuid)
        let expectedUrl = URL(string: "https://randomuser.me/api/portraits/women/82.jpg")!
        XCTAssertEqual(expectedUrl, user?.picture.large)
    }

    private func usersFrom(json: String) throws -> Users {
        let data = json.data(using: .utf8)!
        return try JSONDecoder().decode(Users.self, from: data)
    }

    let singleUserResults = """
     {
        "results": [
            {
                "gender": "female",
                "name": {
                    "title": "ms",
                    "first": "jennifer",
                    "last": "white"
                },
                "location": {
                    "street": "2603 mill lane",
                    "city": "stevenage",
                    "state": "greater manchester",
                    "postcode": "AY7 3EP",
                    "coordinates": {
                        "latitude": "5.4092",
                        "longitude": "13.5731"
                    },
                    "timezone": {
                        "offset": "+3:00",
                        "description": "Baghdad, Riyadh, Moscow, St. Petersburg"
                    }
                },
                "email": "jennifer.white@example.com",
                "login": {
                    "uuid": "7fa847c6-cc2a-47de-bd61-b93cd9bba351",
                    "username": "bigpanda609",
                    "password": "girlies",
                    "salt": "VjPBY3EY",
                    "md5": "3f093b455241c54a308a1a4292952835",
                    "sha1": "8ec6ddfb5b1a4417c5bf30da314dd1e27feffb69",
                    "sha256": "e8c7e96b54755c8a2c4889fc0bc3de5044f97eb1e102acaab631280fe95214dd"
                },
                "dob": {
                    "date": "1955-07-26T18:19:15Z",
                    "age": 63
                },
                "registered": {
                    "date": "2014-07-17T01:11:57Z",
                    "age": 4
                },
                "phone": "01567 61304",
                "cell": "0777-300-502",
                "id": {
                    "name": "NINO",
                    "value": "EW 91 63 17 K"
                },
                "picture": {
                    "large": "https://randomuser.me/api/portraits/women/82.jpg",
                    "medium": "https://randomuser.me/api/portraits/med/women/82.jpg",
                    "thumbnail": "https://randomuser.me/api/portraits/thumb/women/82.jpg"
                },
                "nat": "GB"
            }
        ]
     }
     """
}
