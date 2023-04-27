//
//  ContentView.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 19/4/23.
//

import SwiftUI

// рандрмный цвет для имитации фото
func randomColor() -> Color {
    let red = Double.random(in: 0...1)
    let green = Double.random(in: 0...1)
    let blue = Double.random(in: 0...1)
    return Color(red: red, green: green, blue: blue)
}

struct PhotoIndex: Identifiable {
    let id: Int
}


struct UserPage: View {
    
    @State private var isFullScreen = false
    @State private var isFullScreenReference = false
    @State private var selectedPortfolioPhotoIndex: PhotoIndex?
    @State private var selectedReferencePhotoIndex: PhotoIndex?
    
    @State private var isGridViewActive: Bool = false
    @State private var destinationView: AnyView = AnyView(EmptyView())
    
    @State private var isSettingsViewPresented = false
    
    @StateObject private var viewModel = SettingsViewModel()
    
    
    var body: some View {
        NavigationView {
            
            VStack {
                HStack {
                    Text("UserNick")
                        .font(.title2)
                    
                    Spacer()
                    
                    Button(action: {
                        isSettingsViewPresented = true
                    }, label: {
                        Image(systemName: "gear")
                    })
                    .fullScreenCover(isPresented: $isSettingsViewPresented) {
                        SettingsView(viewModel: viewModel)
                    }
                }.padding(.horizontal)
                
                VStack {
                    HStack {
                        VStack {
                            AsyncImage(url: URL(string: "https://sun9-61.userapi.com/impg/6mWyCYaNyEI_NcGtp7Mrdyk3qMTYmNQKRuj5pw/Om-BAYOQDlU.jpg?size=2560x1703&quality=96&sign=3411eb246ffbe055278aca16a721b472&type=album")) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .cornerRadius(50)
                                    .overlay(Circle()
                                        .stroke(Color(.label), lineWidth: 1))
                                    .shadow(radius: 10)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 120, height: 120)
                            .padding(.leading, 6)
                        }
                        
                        Spacer()
                        
                        Text("Followers \n777")
                            .multilineTextAlignment(.center)
                        Spacer()
                        Text("Follows \n77")
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }
                
                VStack {
                    HStack {
                        Text(viewModel.username)
                            .padding(.bottom, 1)
                            .font(.headline)
                        Text(viewModel.creatorRole.rawValue)
                            .padding(.bottom, 1)
                        Spacer()
                    }
                    HStack{
                        Text(viewModel.bio)
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
                        destinationView = AnyView(PhotosGridView(photos: Array(portfolio), title: "Portfolio", isDarkTheme: viewModel.isDarkTheme))
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
                    PhotoSlider(selectedPhotoIndex: index.id, photos: portfolio, isDarkTheme: viewModel.isDarkTheme, isFullScreen: $isFullScreen)
                }
                
                // References
                VStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(.label).opacity(0.2))
                    Button(action: {
                        isGridViewActive = true
                        destinationView = AnyView(PhotosGridView(photos: Array(references), title: "References", isDarkTheme: viewModel.isDarkTheme))
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
                    PhotoSlider(selectedPhotoIndex: index.id, photos: references, isDarkTheme: viewModel.isDarkTheme, isFullScreen: $isFullScreenReference)
                }
                
                Spacer()
            }
            .background(NavigationLink("", destination: destinationView, isActive: $isGridViewActive).opacity(0))
        }
    }
}





struct UserPage_Previews: PreviewProvider {
    static var previews: some View {
        UserPage()
    }
}
