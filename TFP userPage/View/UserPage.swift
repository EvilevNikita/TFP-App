//
//  ContentView.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 19/4/23.
//

import SwiftUI

struct UserPage: View {
  @State private var isFullScreen = false
  @State private var selectedPortfolioPhotoIndex: PhotoIndex?
  @State private var selectedReferencePhotoIndex: PhotoIndex?
  @State private var isGridViewActive: Bool = false
  @State private var destinationView: AnyView = AnyView(EmptyView())
  @State private var isSettingsViewPresented = false
  @State private var showingActionSheet = false
  @State private var showingImagePicker = false
  @State private var selectedImage: UIImage?
  @StateObject private var settings = SettingsViewModel()
  @EnvironmentObject var currentUser: CurrentUser
  

  var body: some View {
    NavigationView {
      VStack {
        HStack {
          Spacer()

          Button(action: {
            isSettingsViewPresented = true
          }, label: {
            Image(systemName: "gear")
          })
          .fullScreenCover(isPresented: $isSettingsViewPresented) {
            SettingsView(settings: settings)
              .environmentObject(AuthViewModel())
          }
        }.padding(.horizontal)
          .frame(maxWidth: .infinity)

        VStack {
          HStack {
            VStack {
              if let profileImageURL = currentUser.profileImageURL, let url = URL(string: profileImageURL) {
                AsyncImage(url: url) { image in
                  image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .cornerRadius(50)
                    .overlay(Circle()
                      .stroke(Color(.label), lineWidth: 1))
                    .shadow(radius: 10)
                } placeholder: {
                  ProgressView()
                }
                .frame(width: 100, height: 100)
                .padding(.leading)
              } else {
                Image("person")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .clipShape(Circle())
                  .cornerRadius(50)
                  .overlay(Circle()
                    .stroke(Color(.label), lineWidth: 1))
                  .shadow(radius: 10)
                  .frame(width: 100, height: 100)
                  .padding(.leading)
              }
            }
            .onLongPressGesture(minimumDuration: 0.5) {
              showingActionSheet = true
            }
            .actionSheet(isPresented: $showingActionSheet) {
              ActionSheet(title: Text("Change Profile Photo"), message: Text("Select an option"), buttons: [
                .default(Text("Choose from Gallery")) {
                  showingImagePicker = true
                },
                .destructive(Text("Remove Photo")) {
                  currentUser.deleteProfileImageFromStorage { error in
                    if let error = error {
                      print("Error deleting profile image: \(error)")
                    }
                  }
                },
                .cancel()
              ])
            }
            .sheet(isPresented: $showingImagePicker) {
              ImagePicker(image: $selectedImage)
            }
            .onChange(of: selectedImage) { newImage in
              guard let newImage = newImage else { return }
              currentUser.userDidChooseNewProfileImage(newImage)
            }

            Spacer()
            VStack {
              Text(currentUser.username)
                .font(.system(size: 18, weight: .medium))
                .padding(.bottom, 5)
              HStack {
                Spacer()
                Text("Followers \n777")
                  .multilineTextAlignment(.center)
                Spacer()
                Text("Follows \n77")
                  .multilineTextAlignment(.center)
                Spacer()
              }
              .padding(.bottom, 30)
            }
            Spacer()
          }
        }

        VStack {
          HStack {
            Text(currentUser.creatorRole?.rawValue ?? "")
              .padding(.bottom, 1)
            Spacer()
          }.padding(.top)
          HStack{
            Text(currentUser.bio)
              .font(.system(size: 16))
              .multilineTextAlignment(.leading)
            Spacer()
          }
        }
        .padding(.horizontal)
        .padding(.bottom, 6)

        // Portfolio
        VStack {
          Rectangle()
            .frame(height: 1)
            .foregroundColor(Color(.label).opacity(0.2))
          Button(action: {
            isGridViewActive = true
            destinationView = AnyView(PhotosGridView(photos: Array(portfolio), title: "Portfolio", isDarkTheme: settings.isDarkTheme))
          }) {
            HStack {
              Text("Portfolio")
                .font(.headline)
                .padding(.vertical, 8)
              Text("\(portfolio.count)").opacity(0.6)
                .padding(.vertical, 8)
              Spacer()
              Image(systemName: "chevron.right").opacity(0.5)
            }.padding(.horizontal)
          }
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
              ForEach(portfolio, id: \.self) { index in
                Button(action: {
                  selectedPortfolioPhotoIndex = PhotoIndex(id: index)
                }) {
                  Text("Portfolio \(index)")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .frame(width: 150, height: 150)
                    .background(randomColor())
                }
                .padding(.bottom)
              }
            }
          }
        }
        .fullScreenCover(item: $selectedPortfolioPhotoIndex) { index in
          PhotoSlider(selectedPhotoIndex: index.id, photos: portfolio, isDarkTheme: settings.isDarkTheme, isFullScreen: $isFullScreen)
        }

        // References
        VStack {
          Rectangle()
            .frame(height: 1)
            .foregroundColor(Color(.label).opacity(0.2))
          Button(action: {
            isGridViewActive = true
            destinationView = AnyView(PhotosGridView(photos: Array(references), title: "References", isDarkTheme: settings.isDarkTheme))
          }) {
            HStack {
              Text("References")
                .font(.headline)
                .padding(.vertical, 8)
              Text("\(references.count)").opacity(0.6)
                .padding(.vertical, 8)
              Spacer()
              Image(systemName: "chevron.right").opacity(0.5)
            }.padding(.horizontal)
          }
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
              ForEach(references, id: \.self) { index in
                Button(action: {
                  selectedReferencePhotoIndex = PhotoIndex(id: index)
                }) {
                  Text("Reference \(index)")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .frame(width: 150, height: 150)
                    .background(randomColor())
                }
                .padding(.bottom)
              }
            }
          }
        }
        .fullScreenCover(item: $selectedReferencePhotoIndex) { index in
          PhotoSlider(selectedPhotoIndex: index.id, photos: references, isDarkTheme: settings.isDarkTheme, isFullScreen: $isFullScreen)
        }

        Spacer()
      }
      .background(NavigationLink("", destination: destinationView, isActive: $isGridViewActive).opacity(0))
      .environmentObject(currentUser)
    }
  }
}

struct UserPage_Previews: PreviewProvider {
  static var previews: some View {
    UserPage()
  }
}
