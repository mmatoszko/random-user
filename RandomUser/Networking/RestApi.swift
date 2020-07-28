//
//  RestApi.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 24/12/2018.
//  Copyright © 2018 Mateusz Matoszko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


final class RestApi {

    private let baseURL = URL(string: "https://randomuser.me/")!

    private let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func getUsers(count: Int) -> Single<[User]> {
        let endpoint = "api"
        guard let pathUrl = URL(string: endpoint, relativeTo: baseURL) else {
            return .error(ApiError.unableToCreatePath)
        }

        let params = ["results": String(count)]
        let queryItems = params.map(URLQueryItem.init)
        guard var components = URLComponents(url: pathUrl, resolvingAgainstBaseURL: true) else {
            return .error(ApiError.unableToCreateUrlWithParams(params))
        }
        components.queryItems = queryItems
        guard let url = components.url else {
            return .error(ApiError.unableToCreateUrlWithParams(params))
        }

        let request = URLRequest(url: url)
        return urlSession.rx.data(request: request).map(decodedUsers).asSingle()
    }
}

private func decodedUsers(data: Data) throws -> [User] {
    let users = try JSONDecoder().decode(Users.self, from: data)
    return users.results
}

private enum ApiError: Error {
    case unableToCreatePath
    case unableToCreateUrlWithParams([String: String])
}
