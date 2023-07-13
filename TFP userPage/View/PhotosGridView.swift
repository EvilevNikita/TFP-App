//
//  PortfolioPge.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 24/4/23.
//

import SwiftUI

struct PhotosGridView: View {
    
    let photos: [Int]
    let title: String
    let isDarkTheme: Bool
    @State private var selectedPhotoIndex: PhotoIndex?
    
    @EnvironmentObject var settings: SettingsViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 20) {
                ForEach(photos, id: \.self) { index in
                    Button(action: {
                        selectedPhotoIndex = PhotoIndex(id: index)
                    }) {
                        Text("Photo \(index)")
                            .foregroundColor(.white)
                            .font(.title)
                            .frame(width: 100, height: 100)
                            .background(randomColor())
                    }
                }
            }
            .padding()
        }
        .navigationTitle(title)
        .fullScreenCover(item: $selectedPhotoIndex) { index in
            PhotoSlider(selectedPhotoIndex: index.id, photos: photos, isFullScreen: .constant(false))
        }
    }
}


struct PortfolioPage_Previews: PreviewProvider {
    static var previews: some View {
        let isDarkTheme = UserDefaults.standard.bool(forKey: "isDarkTheme")
        PhotosGridView(photos: [1, 2, 3, 4, 5, 6, 7, 8, 9], title: "Фотографии", isDarkTheme: isDarkTheme)
    }
}
