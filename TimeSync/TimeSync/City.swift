//
//  City.swift
//  TimeSync
//
//  Created by Esther Ramos on 11/01/26.
//

import Foundation

struct City: Identifiable, Equatable, Codable {
    let id: String
    let name: String
    let timezoneIdentifier: String
    
    static func == (lhs: City, rhs: City) -> Bool {
        lhs.id == rhs.id
    }
    
    var currentTime: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: timezoneIdentifier)
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: Date())
    }
    
    var currentDate: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: timezoneIdentifier)
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: Date())
    }
    
    var abbreviation: String {
        let timezone = TimeZone(identifier: timezoneIdentifier) ?? .current
        return timezone.abbreviation() ?? ""
    }
    
    var offsetFromGMT: String {
        let timezone = TimeZone(identifier: timezoneIdentifier) ?? .current
        let hours = timezone.secondsFromGMT() / 3600
        return String(format: "%+d", hours)
    }
}

// Predefined popular cities
extension City {
    static let popularCities: [City] = [
        City(id: "new_york", name: "New York", timezoneIdentifier: "America/New_York"),
        City(id: "london", name: "London", timezoneIdentifier: "Europe/London"),
        City(id: "tokyo", name: "Tokyo", timezoneIdentifier: "Asia/Tokyo"),
        City(id: "sydney", name: "Sydney", timezoneIdentifier: "Australia/Sydney"),
        City(id: "dubai", name: "Dubai", timezoneIdentifier: "Asia/Dubai"),
        City(id: "los_angeles", name: "Los Angeles", timezoneIdentifier: "America/Los_Angeles"),
        City(id: "paris", name: "Paris", timezoneIdentifier: "Europe/Paris"),
        City(id: "singapore", name: "Singapore", timezoneIdentifier: "Asia/Singapore"),
        City(id: "mumbai", name: "Mumbai", timezoneIdentifier: "Asia/Kolkata"),
        City(id: "shanghai", name: "Shanghai", timezoneIdentifier: "Asia/Shanghai"),
        City(id: "berlin", name: "Berlin", timezoneIdentifier: "Europe/Berlin"),
        City(id: "toronto", name: "Toronto", timezoneIdentifier: "America/Toronto")
    ]
}
