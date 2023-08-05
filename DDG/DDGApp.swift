//
//  DDGApp.swift
//  DDG
//
//  Created by Aasem Hany on 05/07/2023.
//

import SwiftUI

 @main
struct DDGApp: App {
    let locationManager = LocationManager()
    var body: some Scene {
        WindowGroup {
            AppTabView().environmentObject(locationManager)
        }
    }
}
