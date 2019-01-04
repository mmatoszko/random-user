//
//  AppDelegate.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 21/12/2018.
//  Copyright © 2018 Mateusz Matoszko. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var userInformationCoordinator: UserInformationCoordinator?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let userInformationCoordinator = UserInformationCoordinator(window: window)
        userInformationCoordinator.start()
        self.userInformationCoordinator = userInformationCoordinator
        return true
    }
}

