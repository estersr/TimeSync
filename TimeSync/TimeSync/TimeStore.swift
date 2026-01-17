//
//  TimeStore.swift
//  TimeSync
//
//  Created by Esther Ramos on 11/01/26.
//

import Foundation
import Combine

class TimeStore: ObservableObject {
    @Published var city1: City
    @Published var city2: City
    @Published var timer: Timer?
    @Published var currentDate = Date()
    
    private let saveKey = "SavedCities"
    
    init() {
        // Load saved cities or use defaults
        if let saved = Self.loadCities() {
            self.city1 = saved.0
            self.city2 = saved.1
        } else {
            self.city1 = City.popularCities[0] // New York
            self.city2 = City.popularCities[1] // London
        }
        
        startTimer()
    }
    
    func swapCities() {
        let temp = city1
        city1 = city2
        city2 = temp
        saveCities()
    }
    
    func updateCity1(to city: City) {
        city1 = city
        saveCities()
    }
    
    func updateCity2(to city: City) {
        city2 = city
        saveCities()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.currentDate = Date()
        }
    }
    
    private func saveCities() {
        let data: [String: String] = [
            "city1_id": city1.id,
            "city2_id": city2.id
        ]
        UserDefaults.standard.set(data, forKey: saveKey)
    }
    
    private static func loadCities() -> (City, City)? {
        guard let data = UserDefaults.standard.dictionary(forKey: "SavedCities") as? [String: String],
              let city1Id = data["city1_id"],
              let city2Id = data["city2_id"],
              let city1 = City.popularCities.first(where: { $0.id == city1Id }),
              let city2 = City.popularCities.first(where: { $0.id == city2Id }) else {
            return nil
        }
        return (city1, city2)
    }
    
    deinit {
        timer?.invalidate()
    }
}
