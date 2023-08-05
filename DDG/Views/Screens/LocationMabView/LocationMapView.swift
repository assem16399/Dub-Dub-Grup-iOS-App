//
//  LocationMapView.swift
//  DDG
//
//  Created by Aasem Hany on 05/07/2023.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var mapViewModel = LocationMabViewModel()
    
    var body: some View {
        ZStack{
            
            Map(coordinateRegion: $mapViewModel.region, showsUserLocation: true, annotationItems: locationManager.locations){ ddgLocation in
                MapMarker(coordinate: ddgLocation.location.coordinate,
                          tint: .brandPrimary
                )
            }
            .tint(.brandSecondary)
            .ignoresSafeArea()
            VStack{
                LogoView(height: 70).shadow(radius: 10)
                
                Spacer()
            }
        }
        .alert(item: $mapViewModel.alertItem){ alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
        
        .onAppear{
            mapViewModel.runStartupChecks()
            if locationManager.locations.isEmpty{
                mapViewModel.getLocations(for: locationManager)
            }
        }
        .sheet(isPresented: $mapViewModel.isOnBoardingDisplyed,
               onDismiss:mapViewModel.checkIfLocationServicesIsEnabled)
        {
            OnBoardingView(isOnBoardingDisplayed: $mapViewModel.isOnBoardingDisplyed)
        }
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView()
    }
}


