//
//  SettingsView.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 27/4/23.
//

import SwiftUI
import Combine

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SettingsViewModel
    @State private var notificationsEnabled = true
    @State private var theme = "Light"
    @State private var creatorRole: CreatorRole = .photographer
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    Section(header: Text("Account")) {
                        TextField("Username", text: $viewModel.username)
                    }
                    
                    Section(header: Text("Creator Role")) {
                        Picker("Role", selection: $viewModel.creatorRole) {
                            ForEach(CreatorRole.allCases, id: \.self) { role in
                                Text(role.rawValue).tag(role)
                            }
                        }
                    }
                    
                    Section(header: Text("Bio")) {
                        TextField("About Yourself (160 characters max)", text: $viewModel.bio)
                            .onReceive(viewModel.bio.publisher.collect()) {
                                let filtered = String($0.prefix(160))
                                if filtered != viewModel.bio {
                                    viewModel.bio = filtered
                                }
                            }
                    }
                    
                    Section(header: Text("Notifications")) {
                        Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    }
                    
                    Section(header: Text("Appearance")) {
                        Toggle("Dark Theme", isOn: $viewModel.isDarkTheme)
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
                            viewModel.save()
                            dismiss()
                        }
                    }
                }
            }
            .colorScheme(viewModel.isDarkTheme ? .dark : .light)
            .onAppear {
                viewModel.load()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    @StateObject static private var viewModel = SettingsViewModel()
    
    static var previews: some View {
        SettingsView(viewModel: viewModel)
    }
}

class SettingsViewModel: ObservableObject {
    @Published var username: String = "Username"
    @Published var bio: String = "Text test text test text test text test text test text test text test text test text test text test text test text test text"
    @Published var isDarkTheme: Bool = false {
        didSet {
            updateColorScheme()
        }
    }
    @Published var creatorRole: CreatorRole = .photographer
    
    private func updateColorScheme() {
        let userInterfaceStyle: UIUserInterfaceStyle = isDarkTheme ? .dark : .light
        UIApplication.shared.windows.first?.rootViewController?.view.overrideUserInterfaceStyle = userInterfaceStyle
    }
    
    // Сохраняем настройки в Userdefaults
    
    init() {
        load()
    }
    
    func save() {
        UserDefaults.standard.set(username, forKey: Keys.usernameKey.rawValue)
        UserDefaults.standard.set(bio, forKey: Keys.bioKey.rawValue)
        UserDefaults.standard.set(isDarkTheme, forKey: Keys.isDarkThemeKey.rawValue)
        UserDefaults.standard.set(creatorRole.rawValue, forKey: Keys.creatorRoleKey.rawValue)
        print("Saved: username: \(username), bio: \(bio), isDarkTheme: \(isDarkTheme), creatorRole: \(creatorRole.rawValue)")
    }

    func load() {
        username = UserDefaults.standard.string(forKey: Keys.usernameKey.rawValue) ?? "Ivlev Nikita"
        bio = UserDefaults.standard.string(forKey: Keys.bioKey.rawValue) ?? "Text test text test text test text test text test text test text test text test text test text test text test text test text"
        isDarkTheme = UserDefaults.standard.bool(forKey: Keys.isDarkThemeKey.rawValue)
        if let savedRole = UserDefaults.standard.string(forKey: Keys.creatorRoleKey.rawValue),
           let role = CreatorRole(rawValue: savedRole) {
            creatorRole = role
        }
        print("Loaded: username: \(username), bio: \(bio), isDarkTheme: \(isDarkTheme), creatorRole: \(creatorRole.rawValue)")
    }
}

