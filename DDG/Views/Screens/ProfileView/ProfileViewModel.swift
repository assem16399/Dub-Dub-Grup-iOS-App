//
//  ProfileViewModel.swift
//  DDG
//
//  Created by Aasem Hany on 30/07/2023.
//

import Foundation
import CloudKit
enum profileContext { case create, update }
extension ProfileView {
    final class ProfileViewModel: ObservableObject{
        
        @Published var userBio:String = ""
        @Published var firstName = ""
        @Published var lastName = ""
        @Published var job = ""
        @Published var avatar = PlaceHolderImage.avatar
        @Published var isShowingPhotoPicker = false
        @Published var alertItem: AlertItem?
        var remainsChars: Int{ 300 - userBio.count }
        @Published var isLoading = false
        var profileContext: profileContext = .create
        
        private var existedProfileRecord: CKRecord? {
            didSet{
                if existedProfileRecord == nil {
                    profileContext = .create
                }
                else{
                    profileContext = .update
                }
            }
        }
        
        var submitButtonTitle:String {
            profileContext == .create ? "Create Profile" : "Update Profile"
        }
        
        func onSubmitButtonPressed() {
            profileContext == .create ? createProfile() : updateProfile()
        }
        
        var isUserCheckedIn: Bool {
            existedProfileRecord?[DDGProfile.kIsCheckedIn] != nil
        }
        
        //    var attributedText: AttributedString{
        //        do{
        //        var text = try AttributedString(markdown:"Bio: \(remainsChars) characters remains")
        //            if let range = text.range(of: "\(remainsChars)") {
        //                text[range].foregroundColor = .brandPrimary
        //                if remainsChars < 0 {
        //                    text[range].foregroundColor = .red
        //                }
        //            }
        //        return text
        //        }
        //        catch{ return "" }
        //    }
        
        private func createProfile() {
            if isValidProfile() { createProfileUsingFormData() }
            else { alertItem = AlertContext.profileNotValid }
        }
        
        func isValidProfile() -> Bool{
            guard !firstName.isEmpty,
                  !lastName.isEmpty,
                  !job.isEmpty,
                  !userBio.isEmpty,
                  avatar != PlaceHolderImage.avatar,
                  userBio.count <= 300
            else { return false }
            return true
        }
        
        
        private func createProfileUsingFormData() {
            showLoadingView()
            
            // Create CKRecord from Profile View Data
            let profileRecord = createProfileRecord()
            
            guard let userRecord = CloudKitManager.shared.userRecord else {
                hideLoadingView()
                alertItem = AlertContext.noUserRecord
                return
            }
            
            // Create reference on UserRecord to point to the DDGProfile we created
            userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
            
            CloudKitManager.shared.createProfileOperation(records: [userRecord, profileRecord]){result in
                DispatchQueue.main.async { [self] in
                    hideLoadingView()
                    switch result {
                    case .success(let savedRecords):
                        // Show Success Alert
                        for record in savedRecords where record.recordType == RecordType.profile {
                            existedProfileRecord = record
                            CloudKitManager.shared.profileRecordId = record.recordID
                        }
                        alertItem = AlertContext.profileCreatedSuccessfully
                    case .failure(_):
                        // Show Error Alert
                        alertItem = AlertContext.failedToCreateProfile
                    }
                }
            }
        }
        
        
        func getProfile() {
            showLoadingView()
            
            guard let userRecord = CloudKitManager.shared.userRecord else {
                hideLoadingView()
                alertItem = AlertContext.noUserRecord
                return
            }
            
            guard let profileRef = userRecord["userProfile"] as? CKRecord.Reference else {
                hideLoadingView()
                return
            }
            
            let profileRecordId = profileRef.recordID
            
            CloudKitManager.shared.fetchRecord(with: profileRecordId){restult in
                DispatchQueue.main.async { [self] in
                    switch restult {
                    case .success(let profileRecord):
                        existedProfileRecord = profileRecord
                        let profile = DDGProfile(record: profileRecord)
                        firstName = profile.firstName
                        lastName = profile.lastName
                        job = profile.companyName
                        userBio = profile.bio
                        avatar = profile.avatarImage
                    case .failure(let error):
                        alertItem = AlertContext.failedToRetrieveProfile
                        print(error.localizedDescription)
                    }
                    hideLoadingView()
                }
            }
        }
        
        func checkOut() {
            guard let existedProfileRecord, isUserCheckedIn else{
                alertItem = AlertContext.failedToUpdateCheckInStatus
                return
            }
            
            
            existedProfileRecord[DDGProfile.kIsCheckedIn] = nil
            existedProfileRecord[DDGProfile.kIsCheckedInNilCheck] = 0
            
            showLoadingView()
            
            CloudKitManager.shared.save(record: existedProfileRecord) { result in
                DispatchQueue.main.async { [self] in
                    switch result {
                    case .success(let savedRecord):
                        self.existedProfileRecord = savedRecord
                        HapticsManager.playSuccessHaptic()

                    case .failure(let failure):
                        alertItem = AlertContext.failedToUpdateCheckInStatus
                        print(failure.localizedDescription)
                    }
                    hideLoadingView()
                }
                
            }
        }
        
        private func createProfileRecord() -> CKRecord{
            let profileRecord = CKRecord(recordType: RecordType.profile)
            populateProfileRecord(with: profileRecord)
            return profileRecord
        }
        
        private  func updateProfile() {
            if (!isValidProfile()){
                alertItem = AlertContext.profileNotValid
                return
            }
            
            populateProfileRecord(with: existedProfileRecord!)
            
            showLoadingView()
            
            CloudKitManager.shared.save(record: existedProfileRecord!){
                result in
                DispatchQueue.main.async { [self] in
                    switch result {
                    case .success(let profileRecord):
                        existedProfileRecord = profileRecord
                        alertItem = AlertContext.profileUpdatedSuccessfully
                    case .failure(let error):
                        alertItem = AlertContext.failedToUpdateProfile
                        print(error.localizedDescription)
                    }
                    hideLoadingView()
                }
            }
        }
        
        private func populateProfileRecord(with profileRecord: CKRecord) {
            profileRecord[DDGProfile.kFirstName] = firstName
            profileRecord[DDGProfile.kLastName] = lastName
            profileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()
            profileRecord[DDGProfile.kCompanyName] = job
            profileRecord[DDGProfile.kBio] = userBio
        }
        
        private func showLoadingView(){ isLoading = true }
        
        private func hideLoadingView(){ isLoading = false }
        
    }
}
