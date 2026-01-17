//
//  TimeSyncApp.swift
//  TimeSync
//
//  Created by Esther Ramos on 11/01/26.
//

import SwiftUI

@main
struct TimeSyncApp: App {
    @StateObject private var timeStore = TimeStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timeStore)
        }
    }
}
