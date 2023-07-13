//
//  CreateUserSignUpView.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 1/5/23.
//

import SwiftUI
import FirebaseAuth

struct CreateNewUserView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var settings: SettingsViewModel
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var user: CurrentUserViewModel
    @State private var loginStatusMessage = ""
    @Binding var email: String
    @Binding var password: String
    @State private var showChooseCityPage = false
    @State private var showTabBar = false
    @State private var shouldShowImagePicker = false
    @State var image: UIImage?
    @State var pickedImage: UIImage?
    @State private var selectedCity: String? {
        didSet {
            settings.city = selectedCity
        }
    }

    @Environment(\.colorScheme) var colorScheme

    @State private var showLoginView = false

    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    Button {
                        shouldShowImagePicker.toggle()
                    } label: {
                        VStack {
                            if let image = self.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 64))
                            } else {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 50))
                                    .padding()
                                    .foregroundColor(Color(.label))
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 64))
                            }
                        }
                        .overlay(RoundedRectangle(cornerRadius: 64)
                            .stroke(Color.black, lineWidth: 1))
                    }
                    .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: {
                        if let pickedImage = pickedImage {
                            self.image = pickedImage
                            self.user.image = pickedImage
                        }
                    }) {
                        ImagePicker(image: $pickedImage)
                    }

                    Form {

                        Section(header: Text("Account")) {
                            VStack {
                                TextField("Username", text: $settings.username)
                            }
                        }

                        Section(header: Text("Creator Role")) {
                            Picker("Role", selection: $settings.creatorRole) {
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
                            VStack {
                                TextField("About Yourself (160 characters max)", text: $settings.bio)
                                    .onReceive(settings.bio.publisher.collect()) {
                                        let filtered = String($0.prefix(160))
                                        if filtered != settings.bio {
                                            settings.bio = filtered
                                        }
                                    }
                            }
                        }
                    }
                }
                .background(Color(.systemGroupedBackground))
                .navigationTitle("Enter your details")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Back") {
                            dismiss()
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            createNewUser()
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showTabBar) {
                TabBar()
            }
        }
    }

    func createNewUser() {
        auth.signUp(email: email, password: password) { success, message in
            loginStatusMessage = message
            if success {
                guard let currentUser = auth.user else {
                    print("Error: current user is nil")
                    return
                }
                user.email = currentUser.email ?? ""
                user.updateProfile(username: settings.username, creatorRole: settings.creatorRole, bio: settings.bio, city: settings.city ?? "")
                user.saveUserToFirestore() { (error) in
                    if let error = error {
                        print("Error creating new user: \(error)")
                    } else {
                        auth.isAuthenticated = true
                        showTabBar = true
                    }
                    user.persistImageToStorage()
                }
            }
        }
    }
}

struct CreateNewUserView_Previews: PreviewProvider {
    @StateObject static private var settings = SettingsViewModel()
    @StateObject static private var auth = AuthViewModel()
    @State static private var email = ""
    @State static private var password = ""

    static var previews: some View {
        CreateNewUserView(settings: settings, email: $email, password: $password)
            .environmentObject(auth)
    }
}
