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
                
                //             MapMarker(coordinate: ddgLocation.location.coordinate,
                //                       tint: .brandPrimary)
                
                MapAnnotation(coordinate:ddgLocation.location.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.75)){
                    DDGAnnotation(location: ddgLocation,profilesCount: mapViewModel.checkedInProfiles[ddgLocation.id,default: 0])
                        .onTapGesture { mapViewModel.selectedMapLocation = ddgLocation }
                }
                
            }
            .tint(.brandSecondary)
            .ignoresSafeArea()
            
            VStack{
                LogoView(height: 70).shadow(radius: 10)
                
                Spacer()
            }
            
        }.alert(item: $mapViewModel.alertItem){ alertItem in
            
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
            
        }
        .onAppear{
            if locationManager.locations.isEmpty{ mapViewModel.getLocations(for: locationManager) }
            
            mapViewModel.getCheckedInCount()
            
        }
        .sheet(isPresented: $mapViewModel.isShowingDetailView){
            NavigationStack{
                LocationDetailsView(viewModel: LocationDetailsViewModel(location: mapViewModel.selectedMapLocation!))
                    .toolbar{
                        ToolbarItem(placement: .navigationBarTrailing){
                            Button{
                                mapViewModel.isShowingDetailView = false
                            } label: { Text("Dismiss") }
                        }
                    }
            }
            .tint(.grubRed)
            
        }
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView()
            .environmentObject(LocationManager())
    }
}


