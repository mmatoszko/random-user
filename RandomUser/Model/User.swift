//
//  User.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 24/12/2018.
//  Copyright © 2018 Mateusz Matoszko. All rights reserved.
//

import Foundation

struct Users: Decodable {
    let results: [User]
}

protocol FullName {
    var fullName: String { get }
}

struct User: Decodable, Hashable, FullName {

    let name: Name
    let email: String
    let login: Login
    let picture: Picture

    struct Name: Decodable {
        let title: String
        let first: String
        let last: String
    }

    struct Login: Decodable {
        let uuid: String
    }

    struct Picture: Decodable {
        let large: URL
        let medium: URL
        let thumbnail: URL
    }

    var fullName: String {
        return "\(name.title) \(name.first) \(name.last)"
    }

    // MARK: - Equatable

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.login.uuid == rhs.login.uuid
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(login.uuid)
    }
}
