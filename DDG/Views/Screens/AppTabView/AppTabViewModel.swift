//
//  AppTabViewModel.swift
//  DDG
//
//  Created by Aasem Hany on 04/09/2023.
//

import SwiftUI
import CoreLocation
import MapKit

final class AppTabViewModel:NSObject, ObservableObject{
    
    
    var deviceLocationManager: CLLocationManager?
    
    @Published var alertItem: AlertItem?
    
    @Published var isOnBoardingDisplayed = false
    
    let kUserOnBoardStatus = "userOnBoardStatus"

    
    var hasUserOnBoarded: Bool {
        return UserDefaults().bool(forKey: kUserOnBoardStatus)
    }
    
    func runStartupChecks() {
        if hasUserOnBoarded {
            checkIfLocationServicesIsEnabled()
        }else{
            isOnBoardingDisplayed = true
            UserDefaults().setValue(true, forKey: kUserOnBoardStatus)
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
}

extension AppTabViewModel: CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuth()
    }
}
