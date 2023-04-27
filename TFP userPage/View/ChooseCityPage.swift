//
//  ChooseCityPage.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 24/4/23.
//

import SwiftUI

struct ChooseCityPage: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var searchQuery = ""
    @Binding var selectedCity: String?
    @State private var selectedCityIndices = [Bool](repeating: false, count: cities.count)
    
    var filteredCities: [String] {
        if searchQuery.isEmpty {
            return cities
        } else {
            return cities.filter { $0.lowercased().contains(searchQuery.lowercased()) }
        }
    }
    
    var body: some View {
        VStack {
            TextField("Search for a city", text: $searchQuery)
                .padding()
                .padding(.horizontal)
            
            List(filteredCities.indices, id: \.self) { index in
                let city = filteredCities[index]
                HStack {
                    Text(city)
                    
                    if selectedCityIndices[index] {
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                }
                .onTapGesture {
                    // Reset all other selections
                    for i in selectedCityIndices.indices where i != index {
                        selectedCityIndices[i] = false
                    }
                    
                    selectedCityIndices[index].toggle()
                    selectedCity = selectedCityIndices[index] ? city : nil
                    
                    if let city = selectedCity {
                        UserDefaults.standard.set(city, forKey: "selectedCity")
                    } else {
                        UserDefaults.standard.removeObject(forKey: "selectedCity")
                    }
                }
            }
        }.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .navigationBarTitle("Cities")
    }
}
