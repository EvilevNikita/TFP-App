//
//  TabBar.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 24/4/23.
//

import SwiftUI

struct TabBar: View {

  @State private var currentUser = CurrentUser()
  @StateObject private var settings = SettingsViewModel()
  
  init() {
    let tabBarAppearance = UITabBarAppearance()
    tabBarAppearance.configureWithOpaqueBackground()
    tabBarAppearance.backgroundColor = UIColor.systemBackground
    tabBarAppearance.shadowColor = .clear
    UITabBar.appearance().standardAppearance = tabBarAppearance
  }
  
  var body: some View {
    TabView {
      NewPublications()
        .tabItem {
          Label("", systemImage: "star")
            .environment(\.symbolVariants, .none)
        }
        .background(Color.clear)
      
      SearchingPage()
        .tabItem {
          Label("", systemImage: "magnifyingglass")
            .environment(\.symbolVariants, .none)
        }
        .background(Color.clear)
      
      MainMessagesView()
        .tabItem {
          Label("", systemImage: "message")
            .environment(\.symbolVariants, .none)
        }
        .background(Color.clear)
      
      UserPage()
        .tabItem {
          Label("", systemImage: "person")
            .environment(\.symbolVariants, .none)
        }
        .background(Color.clear)
    }
    .accentColor(Color(.label))
    .edgesIgnoringSafeArea(.all)
  }
}

struct TabBar_Previews: PreviewProvider {
  
  static var previews: some View {
    TabBar()
  }
}

