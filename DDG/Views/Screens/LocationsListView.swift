//
//  LocationsListView.swift
//  DDG
//
//  Created by Aasem Hany on 05/07/2023.
//

import SwiftUI

struct LocationsListView: View {
    @EnvironmentObject private var locationManager: LocationManager
     
    var body: some View {
        NavigationStack{
            List{
                ForEach(locationManager.locations){location in
                    NavigationLink(destination: {                         LocationDetailsView(viewModel: LocationDetailsViewModel(location: location))
                    }, label: {
                        LocationsCell(location: location)
                            .padding(.trailing)
                    })
                }
            }
            .listStyle(.plain)
            .navigationTitle("Grub Spots")
            .ignoresSafeArea(edges: .trailing)
        }
    }
}

struct LocationsListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsListView()
    }
}
