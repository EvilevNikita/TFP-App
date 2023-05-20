//
//  SettingsView.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 27/4/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct SettingsView: View {

  @Environment(\.dismiss) var dismiss
  @ObservedObject var settings: SettingsViewModel
  @EnvironmentObject var auth: AuthViewModel

  @State private var notificationsEnabled = true
  @State private var shouldShowLogoutOption = false

  @Environment(\.colorScheme) var colorScheme

  @EnvironmentObject var user: CurrentUser

  @State private var username: String = ""
  @State private var bio: String = ""
  @State private var city: String = ""
  @State private var creatorRole: CreatorRole = .photographer

  @State private var showLoginView = false
  @State private var showChooseCityPage = false

  @State private var selectedCity: String? {
    didSet {
      settings.city = selectedCity
    }
  }

  var body: some View {

    ZStack {
      NavigationView {
        Form {
          Section(header: Text("Account")) {
            TextField("Username", text: $username)
          }

          Section(header: Text("Creator Role")) {
            Picker("Role", selection: $creatorRole) {
              ForEach(CreatorRole.allCases, id: \.self) { role in
                Text(role.rawValue).tag(role)
              }
            }
          }

          Section(header: Text("City")) {
            Button(action: {
              showChooseCityPage = true
            }, label: {
              HStack {
                Text(selectedCity ?? "Choose a city")
                  .foregroundColor(selectedCity == nil ? .gray : .primary)
                Spacer()
                let cityBinding = Binding<String?>(
                  get: { selectedCity },
                  set: { selectedCity = $0?.isEmpty == true ? nil : $0 }
                )
                NavigationLink(destination: ChooseCityPage(selectedCity: cityBinding), isActive: $showChooseCityPage) {
                  EmptyView()
                }
              }
            })
          }

          Section(header: Text("Bio")) {
            TextField("About Yourself (160 characters max)", text: $bio)
              .onReceive(bio.publisher.collect()) {
                let filtered = String($0.prefix(160))
                if filtered != bio {
                  bio = filtered
                }
              }
          }
          Section(header: Text("Notifications")) {
            Toggle("Enable Notifications", isOn: $notificationsEnabled)
          }

          Section(header: Text("Appearance")) {
            Toggle("Dark Theme", isOn: $settings.isDarkTheme)
          }

          Section {
            Button(action: {
              shouldShowLogoutOption.toggle()
            }) {
              Text("Sign Out")
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .center)
            }
          }
        }

        .navigationTitle("Settings")
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button("Back") {
              dismiss()
            }
          }

          ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
              user.updateProfile(username: username, creatorRole: creatorRole, bio: bio, city: selectedCity ?? "")
              user.saveUserToFirestore(user: user) { (error) in
                if let error = error {
                  print("Error updating user: \(error)")
                } else {
                  dismiss()
                }
              }
            }
          }
        }
        .colorScheme(settings.isDarkTheme ? .dark : .light)
      }
    }
    .actionSheet(isPresented: $shouldShowLogoutOption) {
      ActionSheet(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
        .destructive(Text("Sign out"), action: {
          auth.handleSignOut()
        }),
        .cancel()
      ])
    }
    .fullScreenCover(isPresented: $showLoginView) {
      LoginView()
    }
    .colorScheme(settings.isDarkTheme ? .dark : .light)
    .onAppear {
      username = user.username
      bio = user.bio
      selectedCity = user.city
      creatorRole = user.creatorRole ?? .photographer
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  @StateObject static private var settings = SettingsViewModel()
  @StateObject static private var auth = AuthViewModel()

  static let sampleData: [String: Any] = [
    "uid": "sampleUID",
    "email": "test@example.com",
    "username": "testuser",
    "bio": "I am a test user.",
    "city": "San Francisco",
    "profileImageURL": "",
    "creatorRole": CreatorRole.photographer.rawValue
  ]

  @State static private var currentUser = CurrentUser(data: sampleData)

  static var previews: some View {
    SettingsView(settings: settings)
      .environmentObject(auth)
  }
}
