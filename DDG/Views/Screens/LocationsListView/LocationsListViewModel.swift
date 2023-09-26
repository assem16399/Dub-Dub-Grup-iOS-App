//
//  LocationsListViewModel.swift
//  DDG
//
//  Created by Aasem Hany on 21/08/2023.
//

import CloudKit
import SwiftUI
extension LocationsListView {
    
    final class LocationsListViewModel: ObservableObject{
        
        @Published var alertItem: AlertItem?
        @Published var checkedInProfiles = [CKRecord.ID:[(DDGProfile)]]()
        
        func getAllPlaceCheckedInProfiles() {
            CloudKitManager.shared.getAllPlacesCheckedInProfiles{result in
                DispatchQueue.main.async {[self] in
                    switch result {
                    case .success(let checkedInProfiles):
                        self.checkedInProfiles = checkedInProfiles
                    case .failure(let failure):
                        alertItem = AlertContext.failedToAllGetCheckedInProfiles
                        print("Error Getting Back Profile Dic: \(failure.localizedDescription)")
                    }
                }
                
            }
        }
        
       @ViewBuilder func createLocationDetailsView(for location: DDGLocation, in dynamicTypeSize: DynamicTypeSize) -> some View{
            if dynamicTypeSize >= .accessibility1 {
                LocationDetailsView(viewModel: LocationDetailsView.LocationDetailsViewModel(location: location)).embedInScrollView()
            }else {
                LocationDetailsView(viewModel: LocationDetailsView.LocationDetailsViewModel(location: location))
            }
        }
        
        func getVoiceOverSummary(for location:DDGLocation) -> String {
            let locationCheckedInProfiles = checkedInProfiles[location.id, default: []]
            let personOrPeople = locationCheckedInProfiles.count == 1 ? "Person" : "People"
            
           return "\(location.name), \(checkedInProfiles.count) \(personOrPeople) checked in."
        }
        
    }
    
   

}
