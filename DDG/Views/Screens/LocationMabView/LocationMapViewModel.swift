//
//  LocationMapViewModel.swift
//  DDG
//
//  Created by Aasem Hany on 09/07/2023.
//

import SwiftUI
import MapKit
import CloudKit

final class LocationMabViewModel: ObservableObject{
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),
        span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @Published var checkedInProfiles = [CKRecord.ID : Int]()
    @Published var isShowingDetailView = false
    @Published var alertItem: AlertItem?
    
    var selectedMapLocation: DDGLocation?{
        didSet{
            isShowingDetailView = true
        }
    }
    
    func getLocations(for locationManager: LocationManager) {
        CloudKitManager.shared.getLocations{ result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let locations):
                    locationManager.locations = locations
                case .failure(let error):
                    print(error.localizedDescription)
                    alertItem = AlertContext.unableToGetLocations
                }
            }
        }
    }
    
    func getCheckedInCount() {
        CloudKitManager.shared.getAllPlacesCheckedInProfilesCount{ result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let checkedInProfiles):
                    self.checkedInProfiles = checkedInProfiles
                case .failure(_):
                    alertItem = AlertContext.unableToGetLocations
                }
            }
        }
    }
}

