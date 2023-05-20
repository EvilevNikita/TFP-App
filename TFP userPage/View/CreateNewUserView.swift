//
//  CreateUserSignUpView.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 1/5/23.
//

import SwiftUI
import FirebaseAuth

struct CreateUserView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SettingsViewModel
    @EnvironmentObject var auth: AuthViewModel
    @State private var notificationsEnabled = true
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showLoginView = false
    
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
        }
        .onAppear {
            viewModel.load()
        }
//        auth.signUp(email: email, password: password, image: image) { success, message in
//            loginStatusMessage = message
//            if success {
//                auth.isAuthenticated = true
//            }
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    @StateObject static private var viewModel = SettingsViewModel()
    @StateObject static private var auth = AuthViewModel()
    
    static var previews: some View {
        SettingsView(viewModel: viewModel)
            .environmentObject(auth)
    }
}
