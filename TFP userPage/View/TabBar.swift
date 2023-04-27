//
//  TabBar.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 24/4/23.
//

import SwiftUI

struct TabBar: View {
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground // Задайте нужный цвет здесь
        tabBarAppearance.shadowColor = .clear // Убираем тень
        UITabBar.appearance().standardAppearance = tabBarAppearance
    }

    var body: some View {
        TabView {
            NewPublications()
                .tabItem {
                    Image(systemName: "star")
                }
                .background(Color.clear)
            
            SearchingPage()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .background(Color.clear)
            
            UserPage()
                .tabItem {
                    Image(systemName: "person")
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

