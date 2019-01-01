//
//  UserRepositoryTests.swift
//  RandomUserTests
//
//  Created by Mateusz Matoszko on 31/12/2018.
//  Copyright © 2018 Mateusz Matoszko. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import RandomUser


class UserRepositoryTests: XCTestCase {

    func testItShouldProvidePersistedUsers() throws {
        let userStore = TestUserStore()
        userStore.persistAsync(users: [User(uuid: "first")])
        let repository = UserRepository(remoteUsersCallback: testRemoteUsersCallback, userStore: userStore)
        XCTAssertEqual("first", try repository.getUsers().toBlocking().single().first?.login.uuid)
    }

    func testItShouldProvideRemoteUsersWhenThereAreNoPersistedUsers() {
        let userStore = TestUserStore()
        let repository = UserRepository(remoteUsersCallback: testRemoteUsersCallback, userStore: userStore)
        XCTAssertEqual("remote", try repository.getUsers().toBlocking().single().first?.login.uuid)
    }

    func testItShouldUpdatePersistedUsersWhenThereAreNoPersistedUsers() {
        let userStore = TestUserStore()
        let remoteCallback = { return Observable.just([User(uuid: "remote user")]) }
        let repository = UserRepository(remoteUsersCallback: remoteCallback, userStore: userStore)
        guard let remote = try? repository.getUsers().toBlocking().single() else {
            return XCTFail("no remote users")
        }
        XCTAssertEqual("remote user", remote.first?.login.uuid)
        let loadUsersExpectation = expectation(description: "User store should load users")
        userStore.loadUsers { users in
            XCTAssertEqual("remote user", users.first?.login.uuid)
            loadUsersExpectation.fulfill()
        }
        wait(for: [loadUsersExpectation], timeout: 0)
    }

    func testGettingFreshUsersShouldReachOutForRemoteUsers() {
        let userStore = TestUserStore()
        userStore.persistAsync(users: [User(uuid: "first")])
        let repository = UserRepository(remoteUsersCallback: testRemoteUsersCallback, userStore: userStore)
        XCTAssertEqual("remote", try repository.getFreshUsers().toBlocking().single().first?.login.uuid)
    }

    func testGettingFreshUsersShouldUpdatePersistedUsers() {
        let userStore = TestUserStore()
        let remoteCallback = { return Observable.just([User(uuid: "fresh user")]) }
        let repository = UserRepository(remoteUsersCallback: remoteCallback, userStore: userStore)
        guard let remote = try? repository.getFreshUsers().toBlocking().single() else {
            return XCTFail("no fresh remote users")
        }
        XCTAssertEqual("fresh user", remote.first?.login.uuid)
        let loadFreshUsersExpectation = expectation(description: "User store should load users")
        userStore.loadUsers { users in
            XCTAssertEqual("fresh user", users.first?.login.uuid)
            loadFreshUsersExpectation.fulfill()
        }
        wait(for: [loadFreshUsersExpectation], timeout: 0)
    }

}

private class TestUserStore: UserPersisting {

    private var persisted: [User] = []

    func persistAsync(users: [User]) {
        persisted = users
    }

    func loadUsers(callback: ([User]) -> Void) {
        callback(persisted)
    }
}

private func testRemoteUsersCallback() -> Observable<[User]> {
    return Observable.just([User(uuid: "remote")])
}

private extension User {
    init(uuid: String) {
        let email = "john.doe@example.com"
        let login = Login(uuid: uuid)
        let name = Name(title: "mr", first: "John", last: "Doe")
        let url = URL(staticString: "http://example.com/user.png")
        let picture = Picture(large: url, medium: url, thumbnail: url)
        self.init(name: name, email: email, login: login, picture: picture)
    }
}

private extension URL {
    init(staticString: StaticString) {
        // this is the best thing to do, but only in tests
        self.init(string: staticString.description)!
    }
}
