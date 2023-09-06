//
//  LocationDetailsViewModel.swift
//  DDG
//
//  Created by Aasem Hany on 05/08/2023.
//

import Foundation
import MapKit
import CloudKit

enum CheckInStatus { case checkedIn, checkedOut }

final class LocationDetailsViewModel: ObservableObject{
    let location: DDGLocation
    @Published var alertItem: AlertItem?
    @Published var isCheckedInProfileDisplayed = false
    @Published var checkedInProfiles = [DDGProfile]()
    @Published var isUserCheckedIn = false
    @Published var isLoading = false
    
    init(location: DDGLocation) { self.location = location }
    
    func getDirections() {
        // Get the placemark of the location on the Map
        let placemark = MKPlacemark(coordinate: location.location.coordinate)
        // Create mapItem using this place mark
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.name
        // Open this mapItem in maps with some custome options (i.e walking directions)
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
        // create a direction from point to point or multiple points
        // MKMapItem.openMaps(with: <#T##[MKMapItem]#>, launchOptions: <#T##[String : Any]?#>)
    }
    
    func callLocationNumber() {
        guard let url = URL(string: "tel://\(location.phoneNumber)") else {
            alertItem = AlertContext.invalidPhoneNumber
            return
        }
        if UIApplication.shared.canOpenURL(url) { UIApplication.shared.open(url) }
        else { alertItem = AlertContext.invalidDevice }
    }
    
    func changeCheckInStatus(to checkInStatus: CheckInStatus) {
        // Retrieve DGGProfile
        guard let profileRecordId = CloudKitManager.shared.profileRecordId else {
            alertItem = AlertContext.failedToRetrieveProfile
            return
        }
        
        CloudKitManager.shared.fetchRecord(with: profileRecordId){ [self] result in
            switch result {
            case .success(let userRecord):
                // Check for checkInStatus
                changeCheckInReference(to: checkInStatus, of: userRecord)
                // Save updatedProfile to the cloudKit
                CloudKitManager.shared.save(record: userRecord) { result in
                    DispatchQueue.main.async { [self] in
                        switch result {
                        case .success(let savedRecord):
                            updateCheckedInProfileBased(on: checkInStatus, with: savedRecord)
                        case .failure(let failure):
                            alertItem = AlertContext.failedToUpdateCheckInStatus
                            print(failure.localizedDescription)
                        }
                    }
                }
            case .failure(let failure):
                alertItem = AlertContext.failedToRetrieveProfile
                print(failure.localizedDescription)
            }
        }
    }
    
    private func updateCheckedInProfileBased(on checkInStatus: CheckInStatus, with userRecord:CKRecord) {
        let profile = DDGProfile(record: userRecord)
        switch checkInStatus {
        case .checkedIn:
            checkedInProfiles.append(profile)
        case .checkedOut:
            checkedInProfiles.removeAll{$0.id == profile.id}
        }
        isUserCheckedIn.toggle()
    }
    
    private func changeCheckInReference(to checkInStatus: CheckInStatus, of userRecord: CKRecord) {
        switch checkInStatus {
            // If user is checking in
        case .checkedIn:
            // Create a reference to the location
            userRecord[DDGProfile.kIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
            userRecord[DDGProfile.kIsCheckedInNilCheck] = 1
            // If user is checking out
        case .checkedOut:
            // Delete the location reference he has
            userRecord[DDGProfile.kIsCheckedIn] = nil
            userRecord[DDGProfile.kIsCheckedInNilCheck] = 0

        }
    }
    
    func getCheckedInProfiles() {
        showLoadingView()
        CloudKitManager.shared.getCheckedProfiles(in: location.id) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let profiles):
                    checkedInProfiles = profiles
                    getCheckedInStatus()
                case .failure(let failure):
                    alertItem = AlertContext.failedToGetCheckedInProfiles
                    print(failure.localizedDescription)
                }
                hideLoadingView()
            }
        }
    }
    
    private func getCheckedInStatus() {
        guard let profileRecordId = CloudKitManager.shared.profileRecordId, !checkedInProfiles.isEmpty else {
            isUserCheckedIn = false
            return
        }
        for checkedInProfile in checkedInProfiles {
            if checkedInProfile.id == profileRecordId {
                isUserCheckedIn = true
                print("Inside Loop")

                print(isUserCheckedIn)
                break
            }else{
                isUserCheckedIn = false
            }
        }
        print(isUserCheckedIn)

    }
    
    func showLoadingView() { isLoading = true }
    
    func hideLoadingView() { isLoading = false }
}
