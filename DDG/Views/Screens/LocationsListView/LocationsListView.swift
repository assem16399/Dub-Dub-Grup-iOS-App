//
//  LocationsListView.swift
//  DDG
//
//  Created by Aasem Hany on 05/07/2023.
//

import SwiftUI

struct LocationsListView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var viewModel = LocationsListViewModel()
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(locationManager.locations){ location in
                    NavigationLink(value: location, label: {
                        LocationsCell(location: location,
                                      checkedInProfiles: viewModel.checkedInProfiles[location.id] ?? [])
                            .padding(.trailing)
                    })
                }
            }
            .listStyle(.plain)
            .navigationTitle("Locations")
            .navigationDestination(for: DDGLocation.self){ location in
                LocationDetailsView(viewModel: LocationDetailsViewModel(location: location))
                    .navigationTitle("Grub Spots")
                    .ignoresSafeArea(edges: .trailing)
            }.onAppear{ viewModel.getAllPlaceCheckedInProfiles() }

        }
    }
}
struct LocationsListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsListView()
            .environmentObject(LocationManager())
    }
}
