//
//  PhotoSlider.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 25/4/23.
//

import SwiftUI

struct PhotoSlider: View {
  let selectedPhotoIndex: Int
  let photos: [Int]
  let isDarkTheme: Bool
  @Binding var isFullScreen: Bool
  @Environment(\.dismiss) var dismiss

  @State private var offset: CGFloat = 0
  @State private var shouldDismiss: Bool = false
  @State private var magnification: CGFloat = 1.0
  @State private var temporaryMagnification: CGFloat = 1.0

  @StateObject private var viewModel = SettingsViewModel()

  var body: some View {
    ZStack{
      NavigationView {
        VStack {
          Spacer()
          TabView(selection: .constant(selectedPhotoIndex)) {
            ForEach(photos, id: \.self) { index in
              VStack {
                Text("Photo \(index)")
                  .font(.largeTitle)
                  .padding()
              }
              .tag(index)
              .frame(width: 500, height: 300)
              .background(randomColor())
              .scaleEffect(magnification * temporaryMagnification)
              .gesture(
                MagnificationGesture()
                  .onChanged { value in
                    self.temporaryMagnification = value
                  }
                  .onEnded { value in
                    withAnimation(.spring()) {
                      self.magnification *= value
                      self.temporaryMagnification = 1.0
                    }
                  }
              )
            }
          }
          .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
          .frame(width: 500, height: 300)
          .edgesIgnoringSafeArea(.bottom)
          .offset(y: offset)
          .gesture(
            DragGesture(minimumDistance: 10, coordinateSpace: .local)
              .onChanged { value in
                self.offset = value.translation.height
              }
              .onEnded { value in
                if value.translation.height > 100 {
                  self.shouldDismiss = true
                } else {
                  withAnimation(.spring()) {
                    self.offset = 0
                  }
                }
              }
          )
          .onChange(of: shouldDismiss) { value in
            if value {
              DispatchQueue.main.asyncAfter(deadline: .now()) {
                dismiss()
              }
            } else {
              withAnimation(.spring()) {
                offset = 0
                magnification = 1.0
              }
            }
          }

          Spacer()
        }
        .navigationBarTitle("Photos", displayMode: .inline)
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button {
              dismiss()
            } label: {
              HStack{
                Image(systemName: "chevron.backward")
                Text("Back")
              }.foregroundColor(Color(.label))
            }
          }
        }
      }
      .colorScheme(isDarkTheme ? .dark : .light)
    }
  }
}
