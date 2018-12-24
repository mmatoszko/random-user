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

    private let apiUrl = URL(string: "https://randomuser.me/api/?results=5000")!

    private let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func getUsers() -> Observable<[User]> {
        let request = URLRequest(url: apiUrl)
        return urlSession.rx.json(request: request).map { jsonData in
            guard let responseData = jsonData as? [String: Any] else {
                throw ApiError.unexpectedResponse
            }
            return [User()]
        }
    }

    // MARK: - Errors

    enum ApiError: Error {
        case unexpectedResponse
    }
}
