//
//  SettingsViewModel.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 30/4/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth


class SettingsViewModel: ObservableObject {
  @Published var username: String = ""
  @Published var bio: String = ""
  @Published var creatorRole: CreatorRole = .photographer
  @Published var city: String?
  @Published var isDarkTheme: Bool = false {
    didSet {
      updateColorScheme()
    }
  }
  
  private func updateColorScheme() {
    let userInterfaceStyle: UIUserInterfaceStyle = isDarkTheme ? .dark : .light
    UIApplication.shared.windows.first?.rootViewController?.view.overrideUserInterfaceStyle = userInterfaceStyle
  }
}

