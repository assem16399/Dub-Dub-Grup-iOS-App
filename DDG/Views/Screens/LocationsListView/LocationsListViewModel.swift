//
//  LocationsListViewModel.swift
//  DDG
//
//  Created by Aasem Hany on 21/08/2023.
//

import CloudKit

final class LocationsListViewModel: ObservableObject{
    @Published var checkedInProfiles = [CKRecord.ID:[(DDGProfile)]]()
    func getAllPlaceCheckedInProfiles() {
        CloudKitManager.shared.getAllPlacesCheckedInProfiles{result in
            DispatchQueue.main.async {
                switch result {
                case .success(let checkedInProfiles):
                    self.checkedInProfiles = checkedInProfiles
                    print(checkedInProfiles)
                case .failure(let failure):
                    print("Error Getting Back Profile Dic: \(failure.localizedDescription)")
                }
            }
            
        }
    }
    
}
