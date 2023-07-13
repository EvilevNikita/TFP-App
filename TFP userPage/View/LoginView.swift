//
//  LoginView.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 28/4/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isLoginMode = true
    @State private var email = ""
    @State private var password = ""
    @State private var error: String?
    @State private var shouldShowImagePicker = false
    
    @State private var image: UIImage?
    @State private var loginStatusMessage = ""
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var settings: SettingsViewModel
    
    @State private var showCreateNewUserView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker Here")) {
                        Text("login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    } .pickerStyle(SegmentedPickerStyle())
                        .padding()
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.none)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                            Spacer()
                        }
                        .background(.blue)
                        .padding(.horizontal)
                        .font(.system(size: 14, weight: .semibold))
                    }
                    
                    if let error = error {
                        Text(error)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                    
                    Text(self.loginStatusMessage)
                        .foregroundColor(.red)
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea(.all))
        }
        .fullScreenCover(isPresented: $showCreateNewUserView) {
            CreateNewUserView(settings: settings, email: $email, password: $password)
                .environmentObject(auth)
        }
    }
    
    private func handleAction() {
        if isLoginMode {
            auth.signIn(email: email, password: password) { result in
                switch result {
                case .success(_):
                    auth.isAuthenticated = true
                    self.dismiss()
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            }
        } else {
            showCreateNewUserView = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
