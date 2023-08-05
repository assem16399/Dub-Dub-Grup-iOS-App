//
//  ProfileViewModel.swift
//  DDG
//
//  Created by Aasem Hany on 30/07/2023.
//

import Foundation
import CloudKit
enum profileContext { case create, update }
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
    
    //    var attributedText: AttributedString{
    //        do{
    //        var text = try AttributedString(markdown:"Bio: \(remainsChars) charcters remains")
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
    
    func createProfile() {
        if isValidProfile() {
            createProfileFromFormData()
        }else{
            alertItem = AlertContext.profileNotValid
        }
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

    
    private func createProfileFromFormData() {
        showLoadingView()
        // Create CKRecord from Profile View Data
        let profileRecord = createProfileRecord()
        
        guard let userRecord = CloudKitManager.shared.userRecord else {
            // Show Alert
            print("UserRecord is nil")
            hideLoadingView()
            alertItem = AlertContext.noUserRecord
            return
        }
        
        // Create reference on UserRecord to point to the DDGProfile we created
        userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
    
        CloudKitManager.shared.creatProfileOperation(records: [userRecord, profileRecord]){result in
            DispatchQueue.main.async { [self] in
                hideLoadingView()
                switch result {
                case .success(let savedRecords):
                    // Show Success Alert
                    for record in savedRecords where record.recordType == RecordType.profile {
                        existedProfileRecord = record
                    }
                    alertItem = AlertContext.profileCreatedSuccessfully
                    print(savedRecords)
                case .failure(let error):
                    // Show Error Alert
                    alertItem = AlertContext.failedToCreateProfile
                    print(error.localizedDescription)
                }
            }
        }
    }

    
    func getProfile() {
        showLoadingView()
        guard let userRecord = CloudKitManager.shared.userRecord else {
            // Show Alert
            print("UserRecord is nil")
            hideLoadingView()
            alertItem = AlertContext.noUserRecord
            return
        }
        guard let profileRef = userRecord["userProfile"] as? CKRecord.Reference else {
            // Show Alert
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
                    avatar = profile.createAvatarImage()
                case .failure(let error):
                    // Show Alert
                    alertItem = AlertContext.failedToRetrieveProfile
                    print(error.localizedDescription)
                }
                hideLoadingView()
            }
        }
    }
    
    private func createProfileRecord() -> CKRecord{
        let profileRecord = CKRecord(recordType: RecordType.profile)
        populateProfileRecord(profileRecord: profileRecord)
        return profileRecord
    }
    
    func updateProfile() {
        if (!isValidProfile()){
            alertItem = AlertContext.profileNotValid
            return
        }

        populateProfileRecord(profileRecord: existedProfileRecord!)
        
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
    
    private func populateProfileRecord(profileRecord: CKRecord) {
        profileRecord[DDGProfile.kFirstName] = firstName
        profileRecord[DDGProfile.kLastName] = lastName
        profileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()
        profileRecord[DDGProfile.kCompanyName] = job
        profileRecord[DDGProfile.kBio] = userBio
    }
    
    private func showLoadingView(){ isLoading = true }
    
    private func hideLoadingView(){ isLoading = false }
}
