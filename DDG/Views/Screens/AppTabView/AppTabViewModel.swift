//
//  AppTabViewModel.swift
//  DDG
//
//  Created by Aasem Hany on 04/09/2023.
//

import SwiftUI
import CoreLocation
import MapKit

extension AppTabView{
    final class AppTabViewModel:NSObject, ObservableObject, CLLocationManagerDelegate{
        
        @Published var alertItem: AlertItem?
        @Published var isOnBoardingDisplayed = false
        @AppStorage("userOnBoardStatus") var hasSeenOnBoardingView = false{
            didSet{
                isOnBoardingDisplayed = hasSeenOnBoardingView
            }
        }
        var deviceLocationManager: CLLocationManager?
        let kUserOnBoardStatusKey = "userOnBoardStatus"
        
        
        
        func runStartupChecks() {
            if hasSeenOnBoardingView {
                checkIfLocationServicesIsEnabled()
            } else {
                hasSeenOnBoardingView = true
            }
        }
        
        func checkIfLocationServicesIsEnabled() {
            DispatchQueue.global().async {
                if CLLocationManager.locationServicesEnabled() {
                    DispatchQueue.main.async {
                        self.deviceLocationManager = CLLocationManager()
                        //deviceLocationManager?.desiredAccuracy = kCLLocationAccuracyBest // default iOS accuracy
                        self.deviceLocationManager!.delegate = self
                    }
                } else {
                    // Show an alert
                    DispatchQueue.main.async {
                        self.alertItem = AlertContext.locationDisabled
                    }
                }
            }
        }
        
        private func checkLocationAuth() {
            guard let deviceLocationManager else { return }
            switch deviceLocationManager.authorizationStatus {
            case .notDetermined:
                deviceLocationManager.requestWhenInUseAuthorization()
            case .restricted:
                alertItem = AlertContext.locationRestricted
            case .denied:
                alertItem = AlertContext.locationDenied
            case .authorizedAlways, .authorizedWhenInUse:
                break
            @unknown default:
                break
            }
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuth()
        }
    }

    
 
}
