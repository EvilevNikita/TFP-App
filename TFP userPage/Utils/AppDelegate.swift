//
//  AppDelegate.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 3/5/23.
//

import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
