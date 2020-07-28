//
//  UserListInteractorTests.swift
//  RandomUserTests
//
//  Created by Mateusz Matoszko on 28/07/2020.
//  Copyright © 2020 Mateusz Matoszko. All rights reserved.
//

import XCTest
import RxSwift
@testable import RandomUser

class UserListInteractorTests: XCTestCase {

    private var sut: UserListInteractorType!

    override func setUp() {
        let repository = TestUserRepository()
        sut = UserListInteractor(userRepository: repository)
        super.setUp()
    }

    func testLoadUsersNotFiltered() {
        // WHEN
        sut.loadUsers(userCount: 42)

        // THEN
        XCTAssertEqual(["42", "43"], sut.visibleUsers.value.map { $0.login.uuid })
    }

    func testLoadUsersFiltered() {
        // GIVEN
        sut.presentationType.accept(.filtered(predicate: { $0.login.uuid == "42" }))

        // WHEN
        sut.loadUsers(userCount: 42)

        // THEN
        XCTAssertEqual(["42"], sut.visibleUsers.value.map { $0.login.uuid })
    }

    func testRefreshUsersNotFiltered() {
        // WHEN
        sut.refreshUsers(userCount: 42)

        // THEN
        XCTAssertEqual(["fresh", "new"], sut.visibleUsers.value.map { $0.login.uuid })
    }

    func testRefreshUsersFiltered() {
        // GIVEN
        sut.presentationType.accept(.filtered(predicate: { $0.login.uuid == "new" }))

        // WHEN
        sut.refreshUsers(userCount: 42)

        // THEN
        XCTAssertEqual(["new"], sut.visibleUsers.value.map { $0.login.uuid })
    }
}

private class TestUserRepository: UserRepositoryType {
    func getUsers(count: Int) -> Single<[User]> {
        return .just([User(uuid: "42"), User(uuid: "43")])
    }

    func getFreshUsers(count: Int) -> Single<[User]> {
        return .just([User(uuid: "fresh"), User(uuid: "new")])
    }
}
