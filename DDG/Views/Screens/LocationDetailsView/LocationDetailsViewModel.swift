//
//  LocationDetailsViewModel.swift
//  DDG
//
//  Created by Aasem Hany on 05/08/2023.
//

import Foundation
import MapKit


final class LocationDetailsViewModel: ObservableObject{
    let location: DDGLocation
    @Published var alertItem: AlertItem?

    init(location: DDGLocation) {
        self.location = location
    }
    
    func getDirections() {
        // Get the placemark of the location on the Map
        let placemark = MKPlacemark(coordinate: location.location.coordinate)
        // Create mapItem using this placemark
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.name
        
        // Open this mapItem in maps with some custome options (i.e walking directions)
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
        
        // create a direction from point to point or multible points
        // MKMapItem.openMaps(with: <#T##[MKMapItem]#>, launchOptions: <#T##[String : Any]?#>)
    }
    
    func callLocationNumber() {
        guard let url = URL(string: "tel://\(location.phoneNumber)") else {
            alertItem = AlertContext.invalidPhoneNumber
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        else {
            alertItem = AlertContext.invalidDevice
        }
    }
}
