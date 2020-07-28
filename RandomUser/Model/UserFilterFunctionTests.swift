//
//  FilterFunctionTests.swift
//  RandomUserTests
//
//  Created by Mateusz Matoszko on 03/01/2019.
//  Copyright © 2019 Mateusz Matoszko. All rights reserved.
//

import XCTest
@testable import RandomUser


class FilterFunctionTests: XCTestCase {

    func testFilteringWithEmptySearchText() {

        let filterFunctionWithEmptyText: (Car) -> Bool = createUsersFilter(searchText: "")
        XCTAssertEqual(14, testObjects.filter(filterFunctionWithEmptyText).count)
    }

    func testFilteringForLowercase() {
        let filterFunctionWithEmptyText: (Car) -> Bool = createUsersFilter(searchText: "m")
        XCTAssertEqual(5, testObjects.filter(filterFunctionWithEmptyText).count)
    }

    func testFilteringForUppercase() {
        let filterFunctionWithEmptyText: (Car) -> Bool = createUsersFilter(searchText: "M")
        XCTAssertEqual(5, testObjects.filter(filterFunctionWithEmptyText).count)
    }
}

private struct Car: FullName {
    var fullName: String
}

private let testObjects = [
    "BMW",
    "Volvo",
    "Mazda",
    "Mercedes-Benz",
    "Koenigsegg",
    "Porsche",
    "Jaguar",
    "Audi",
    "Lincoln",
    "GMC",
    "Pagani",
    "Subaru",
    "Alfa Romeo",
    "Acura"].map(Car.init)
