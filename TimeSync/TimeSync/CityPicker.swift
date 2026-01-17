//
//  CityPicker.swift
//  TimeSync
//
//  Created by Esther Ramos on 17/01/26.
//
import SwiftUI

struct CityPicker: View {
    @Environment(\.dismiss) var dismiss
    let selectedCity: City
    let onSelect: (City) -> Void
    
    @State private var searchText = ""
    
    var filteredCities: [City] {
        if searchText.isEmpty {
            return City.popularCities
        } else {
            return City.popularCities.filter { city in
                city.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    // Quick select current location
                    Button(action: {
                        if let localCity = City.popularCities.first(where: { $0.timezoneIdentifier == TimeZone.current.identifier }) {
                            onSelect(localCity)
                            dismiss()
                        }
                    }) {
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading) {
                                Text("Current Location")
                                    .font(.body)
                                    .fontWeight(.medium)
                                
                                if let localTZ = TimeZone.current.identifier.split(separator: "/").last {
                                    Text(localTZ.replacingOccurrences(of: "_", with: " "))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                Section("Popular Cities") {
                    ForEach(filteredCities) { city in
                        cityRow(city: city)
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("Select City")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func cityRow(city: City) -> some View {
        Button(action: {
            onSelect(city)
            dismiss()
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(city.name)
                            .font(.body)
                        
                        if city.id == selectedCity.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 14))
                        }
                    }
                    
                    HStack(spacing: 12) {
                        Text("UTC\(city.offsetFromGMT)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(city.abbreviation)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(city.currentTime)
                            .font(.caption)
                            .foregroundColor(.blue)
                            .monospacedDigit()
                    }
                }
                
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
