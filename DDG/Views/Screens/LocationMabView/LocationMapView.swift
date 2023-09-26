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
    @StateObject private var viewModel = LocationMabViewModel()
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    var body: some View {
        ZStack(alignment: .top){
            
            Map(coordinateRegion: $viewModel.region,
                showsUserLocation: true,
                annotationItems: locationManager.locations){ ddgLocation in
                
                //             MapMarker(coordinate: ddgLocation.location.coordinate,
                //                       tint: .brandPrimary)
                MapAnnotation(coordinate:ddgLocation.location.coordinate,
                              anchorPoint: CGPoint(x: 0.5, y: 0.75)){
                    
                    let checkedInProfilesCount = viewModel.checkedInProfiles[ddgLocation.id,default: 0]
                    DDGAnnotation(location: ddgLocation,
                                  profilesCount: checkedInProfilesCount)
                    .onTapGesture { viewModel.selectedMapLocation = ddgLocation }
                }
                
            }
            .tint(.brandSecondary)
            .ignoresSafeArea()
            
            LogoView(height: 70).shadow(radius: 10)
//                    .accessibilityHidden(true)
        }
        .alert(item: $viewModel.alertItem){ Alert(from: $0) }
        .onAppear{
            if locationManager.locations.isEmpty{ viewModel.getLocations(for: locationManager) }
            
            viewModel.getCheckedInCount()
            
        }
        .sheet(isPresented: $viewModel.isShowingDetailView){
            NavigationStack{
                viewModel.createLocationDetailsView(in: dynamicTypeSize)
                    .toolbar{
                        ToolbarItem(placement: .navigationBarTrailing){
                            Button{
                                viewModel.isShowingDetailView = false
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


