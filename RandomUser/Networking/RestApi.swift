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

    private let apiUrl = URL(string: "https://randomuser.me/api/?results=150")!

    private let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func getUsers() -> Observable<[User]> {
        let request = URLRequest(url: apiUrl)
        return urlSession.rx.data(request: request).map { data in

            let users = try JSONDecoder().decode(Users.self, from: data)
            return users.results
        }
    }
}
