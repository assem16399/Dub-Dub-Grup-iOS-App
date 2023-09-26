//
//  LocationDetailsViewModel.swift
//  DDG
//
//  Created by Aasem Hany on 05/08/2023.
//

import Foundation
import MapKit
import CloudKit
import SwiftUI

enum CheckInStatus { case checkedIn, checkedOut }

extension LocationDetailsView {
    
    final class LocationDetailsViewModel: ObservableObject{
        let location: DDGLocation
        @Published var alertItem: AlertItem?
        @Published var isCheckedInProfileModalDisplayed = false
        @Published var isCheckedInProfileSheetDisplayed = false
        @Published var checkedInProfiles = [DDGProfile]()
        @Published var isUserCheckedIn = false
        @Published var isLoading = false
        var checkInButtonColor: Color { isUserCheckedIn ? .grubRed : .brandPrimary }
        var checkInButtonIcon: String { isUserCheckedIn ? "person.fill.xmark" : "person.fill.checkmark" }
        var checkInButtonA11yLabel: String { isUserCheckedIn  ? "Checkout of location" : "Check in into location" }
        
        var selectedProfile: DDGProfile?
        
        init(location: DDGLocation) { self.location = location }
        
        func showDetails(of profile: DDGProfile, in dynamicType: DynamicTypeSize){
            selectedProfile = profile
            if dynamicType >= .accessibility1 {
                isCheckedInProfileSheetDisplayed = true
            }else {
                isCheckedInProfileModalDisplayed = true
            }
        }
        
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
        
        func changeCheckInStatus() {
            let newCheckInStatus: CheckInStatus = isUserCheckedIn ? .checkedOut : .checkedIn
            showLoadingView()
            
            // Retrieve DGGProfile
            guard let profileRecordId = CloudKitManager.shared.profileRecordId else {
                alertItem = AlertContext.failedToRetrieveProfile
                hideLoadingView()
                return
            }
            CloudKitManager.shared.fetchRecord(with: profileRecordId){ result in
                DispatchQueue.main.async { [self] in
                    switch result {
                    case .success(let userRecord):
                        // Check for checkInStatus Localy in memory
                        changeCheckInReference(to: newCheckInStatus, of: userRecord)
                        // Save updatedProfile to the cloudKit
                        CloudKitManager.shared.save(record: userRecord) { result in
                            DispatchQueue.main.async { [self] in
                                switch result {
                                case .success(let savedRecord):
                                    updateCheckedInProfileBased(on: newCheckInStatus, with: savedRecord)
                                    HapticsManager.playSuccessHaptic()
                                case .failure(_):
                                    alertItem = AlertContext.failedToUpdateCheckInStatus
                                }
                                hideLoadingView(from: "Change Check In Status")
                                
                            }
                            
                        }
                        
                        
                    case .failure(_):
                        
                        alertItem = AlertContext.failedToRetrieveProfile
                        
                        
                        hideLoadingView(from: "Change Check In Status")
                        
                    }
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
                    case .failure(_):
                        alertItem = AlertContext.failedToGetCheckedInProfiles
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
                    break
                } else {
                    isUserCheckedIn = false
                }
            }
        }
        
        func showLoadingView() { isLoading = true }
        
        func hideLoadingView(from:String = "Default") { isLoading = false }
    }
    
}
