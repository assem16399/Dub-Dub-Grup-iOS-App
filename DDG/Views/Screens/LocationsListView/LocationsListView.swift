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
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    var body: some View {
        List{
            ForEach(locationManager.locations){ location in
                NavigationLink(
                    destination:
                        viewModel.createLocationDetailsView(for: location,
                                                            in: dynamicTypeSize))
                {
                    let checkedInProfiles = viewModel.checkedInProfiles[location.id, default: []]
                    LocationsCell(location: location,
                                  checkedInProfiles: checkedInProfiles)
                    .listRowSeparatorTint(.brandPrimary)
                    .padding(.trailing)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(
                        Text(viewModel.getVoiceOverSummary(for: location)))
                }
                
            }
        }
        .listStyle(.plain)
        .alert(item: $viewModel.alertItem){Alert(from: $0)}
        .navigationTitle("Locations")
        .onAppear{ viewModel.getAllPlaceCheckedInProfiles() }
    }
}
struct LocationsListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsListView()
            .environmentObject(LocationManager())
    }
}
