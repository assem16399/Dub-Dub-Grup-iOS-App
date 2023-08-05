//
//  LocationMapViewModel.swift
//  DDG
//
//  Created by Aasem Hany on 09/07/2023.
//

import SwiftUI
import MapKit

final class LocationMabViewModel: NSObject, ObservableObject{
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),
        span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @Published var alertItem: AlertItem?
    
    
    @Published var isOnBoardingDisplyed = false
    
    var deviceLocationManager: CLLocationManager?

    let kUserOnBoardStatus = "userOnBoardStatus"
    
    var hasUserOnBoarded: Bool {
        return UserDefaults().bool(forKey: kUserOnBoardStatus)
    }
    
    func runStartupChecks() {
        if hasUserOnBoarded {
            checkIfLocationServicesIsEnabled()
        }else{
            isOnBoardingDisplyed = true
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
    
    func getLocations(for locationManager: LocationManager) {
        DispatchQueue.main.async {
            CloudKitManager.shared.getLocations{
                [self] result in
                switch result {
                case .success(let locations):
                    locationManager.locations = locations
                case .failure(_):
                    alertItem = AlertContext.unableToGetLocations
                }
            }
        }
    }
}

extension LocationMabViewModel: CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuth()
    }
}
