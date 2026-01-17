//
//  ContentView.swift
//  TimeSync
//
//  Created by Esther Ramos on 11/01/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var timeStore: TimeStore
    @State private var showingCityPicker1 = false
    @State private var showingCityPicker2 = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // City 1 Card
                    cityCard(city: timeStore.city1, isLeft: true)
                        .onTapGesture {
                            showingCityPicker1 = true
                        }
                    
                    // Time Comparison Bar
                    HStack {
                        VStack {
                            Text(timeDifference(from: timeStore.city1, to: timeStore.city2))
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                            Text("hours ahead")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            timeStore.swapCities()
                        }) {
                            Image(systemName: "arrow.left.arrow.right.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.blue)
                                .symbolRenderingMode(.hierarchical)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                        
                        VStack {
                            Text(timeDifference(from: timeStore.city2, to: timeStore.city1))
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                            Text("hours ahead")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    
                    // City 2 Card
                    cityCard(city: timeStore.city2, isLeft: false)
                        .onTapGesture {
                            showingCityPicker2 = true
                        }
                    
                    // World Clock Footer
                    worldClockView
                        .padding(.top, 30)
                        .padding(.bottom, 20) // Added bottom padding for better scrolling
                }
                .padding(.top, 10) // Added top padding
            }
            .navigationTitle("TimeSync")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingCityPicker1) {
                CityPicker(selectedCity: timeStore.city1) { city in
                    timeStore.updateCity1(to: city)
                }
            }
            .sheet(isPresented: $showingCityPicker2) {
                CityPicker(selectedCity: timeStore.city2) { city in
                    timeStore.updateCity2(to: city)
                }
            }
        }
    }
    
    private func cityCard(city: City, isLeft: Bool) -> some View {
        VStack(spacing: 15) {
            HStack {
                if isLeft {
                    Text("FROM")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Spacer()
                
                if !isLeft {
                    Text("TO")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 30)
            
            // City Name
            Text(city.name)
                .font(.title)
                .fontWeight(.bold)
            
            // Time Display
            Text(city.currentTime)
                .font(.system(size: 60, weight: .light, design: .rounded))
                .monospacedDigit()
            
            // Date and Timezone Info
            VStack(spacing: 6) {
                Text(city.currentDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 15) {
                    Label(city.abbreviation, systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Label("UTC\(city.offsetFromGMT)", systemImage: "globe")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Tap Hint
            HStack(spacing: 6) {
                Image(systemName: "hand.tap.fill")
                    .font(.caption)
                Text("Tap to change city")
                    .font(.caption)
            }
            .foregroundColor(.blue)
            .opacity(0.7)
            .padding(.top, 5)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(.systemBackground))
                .shadow(color: .gray.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private func timeDifference(from city1: City, to city2: City) -> String {
        let tz1 = TimeZone(identifier: city1.timezoneIdentifier) ?? .current
        let tz2 = TimeZone(identifier: city2.timezoneIdentifier) ?? .current
        
        let diffSeconds = tz2.secondsFromGMT() - tz1.secondsFromGMT()
        let diffHours = Double(diffSeconds) / 3600.0
        
        return String(format: "%+.1f", diffHours)
    }
    
    private var worldClockView: some View {
        VStack(spacing: 10) {
            Text("World Clock")
                .font(.headline)
                .foregroundColor(.secondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(City.popularCities.prefix(8)) { city in
                        worldClockCell(city: city)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private func worldClockCell(city: City) -> some View {
        VStack(spacing: 8) {
            Text(city.name.split(separator: " ").first?.description ?? "")
                .font(.caption)
                .fontWeight(.medium)
            
            Text(city.currentTime)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .monospacedDigit()
            
            Text("UTC\(city.offsetFromGMT)")
                .font(.system(size: 10))
                .foregroundColor(.secondary)
        }
        .frame(width: 70)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .onTapGesture {
            // Set this city to city2 if not already selected
            if city.id != timeStore.city1.id && city.id != timeStore.city2.id {
                timeStore.updateCity2(to: city)
            }
        }
    }
}
