//
//  TFP_userPageApp.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 19/4/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct TFP_userPageApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @StateObject var auth = AuthViewModel()
  @StateObject var settings = SettingsViewModel()
  @StateObject var currentUser = CurrentUser()


  var body: some Scene {
    WindowGroup {
      switch auth.viewState {
      case .loginView:
        LoginView()
          .environmentObject(auth)
          .environmentObject(settings)
          .environmentObject(currentUser)
      case .tabBarView:
        TabBar()
          .environmentObject(auth)
          .environmentObject(settings)
          .environmentObject(currentUser)
          .onAppear {
            currentUser.loadUserData(settings: settings) { success, error in
              if let error = error {
                print("Error loading user data: \(error)")
              } else if success {
                print("User data loaded successfully.")
              } else {
                print("No user data found.")
              }
            }
          }
      }
    }
  }
}
