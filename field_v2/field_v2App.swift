//
//  field_v2App.swift
//  field_v2
//
//  Created by JieDeng on 4/18/26.
//

import SwiftUI

@main
struct FieldTripApp: App {
    @StateObject private var store = FieldTripStore()
    @StateObject private var locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(locationManager)
        }
    }
}
