//
//  CloudKitManager.swift
//  DDG
//
//  Created by Aasem Hany on 05/07/2023.
//

import CloudKit

final class CloudKitManager {

    static let shared = CloudKitManager()
    
    private init(){}
    
    var userRecord: CKRecord?
    var profileRecordId: CKRecord.ID?
    
    
    func getUserRecord() {
        // fetch UserRecordID
        CKContainer.default().fetchUserRecordID{ recordID, error in
            guard let recordID, error == nil else{
                print(error!.localizedDescription)
                return
            }
            // fetch UserRecord from the Public Database using the UserRecordID you got
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID){
                userRecord, error in
                guard let userRecord , error == nil else{
                    print(error!.localizedDescription)
                    return
                }
                self.userRecord = userRecord
                if let profileReference = userRecord["userProfile"] as? CKRecord.Reference{
                    self.profileRecordId = profileReference.recordID
                }
            }
        }
    }
    
    func getLocations(completed: @escaping (Result<[DDGLocation],Error>)-> Void){
        let sortDescriptor = NSSortDescriptor(key: DDGLocation.kName, ascending: true)
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        query.sortDescriptors = [sortDescriptor]
        
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil){ records, error in
            guard let records, error == nil else {
                print(error!.localizedDescription)
                completed(.failure(error!))
                return
            }
            
            //let locations = records.map{DDGLocation(record: $0)}
            let locations = records.map(DDGLocation.init)
            completed(.success(locations))
        }
    }
    
    func createProfileOperation(records:[CKRecord], completed: @escaping (Result<[CKRecord],Error>) -> Void) {
         
        // Create a CKOperation to save our User and Profile Records using patch save
        let operation = CKModifyRecordsOperation(recordsToSave: records)

        operation.modifyRecordsCompletionBlock = {savedRecords, _ , error in
            guard let savedRecords, error == nil else {
                print(error!.localizedDescription)
                completed(.failure(error!))
                return
            }
            completed(.success(savedRecords))
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func getCheckedProfiles(in locationID: CKRecord.ID, completed: @escaping (Result<[DDGProfile], Error>) -> Void) {
        let reference = CKRecord.Reference(recordID: locationID, action: .none)
        let predicate = NSPredicate(format: "\(DDGProfile.kIsCheckedIn) == %@", reference)
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil){
            records, error in
            guard let records, error == nil else {
                completed(.failure(error!))
                return}
            //let profiles = records.map{DDGProfile(record: $0)}
            let profiles = records.map(DDGProfile.init)
            completed(.success(profiles))
        }
    }
    
    private func createGetAllCheckedInProfilesCKOperation() -> CKQueryOperation {
        let predicate = NSPredicate(format: "\(DDGProfile.kIsCheckedInNilCheck) == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        return operation
    }
    
    func getAllPlacesCheckedInProfiles( completed: @escaping (Result<[CKRecord.ID: [DDGProfile]] ,Error>) -> Void) {
       
        let operation = createGetAllCheckedInProfilesCKOperation()
            // Uncomment if u wanna get specific data fields only
        //operation.desiredKeys [DDGProfile.kAvatar, DDGProfile.kIsCheckedIn]
        var checkedInProfiles = [CKRecord.ID: [DDGProfile]]()
        
        // Stream (function to execute after we fetch each record)
        operation.recordFetchedBlock = {record in
            // Build our dictionary
            guard let checkedInLocationRecordRef = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else { return }
            checkedInProfiles[checkedInLocationRecordRef.recordID, default: []].append(DDGProfile(record: record))
        }
        
        operation.queryCompletionBlock = { cursor, error in
            if let error  {
                completed(.failure(error))
                return
            }
            
            if let cursor {
                self.continueAddingToCheckedInProfilesDict(cursor: cursor, dict: checkedInProfiles){result in
                    switch result {
                    case .success(let profiles):
                        completed(.success(profiles))
                    case .failure(let failure):
                        completed(.failure(failure))
                    }
                }
            }else{
                completed(.success(checkedInProfiles))
            }
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)

    }
    
    func continueAddingToCheckedInProfilesDict(cursor: CKQueryOperation.Cursor, dict: [CKRecord.ID : [DDGProfile]], completed: @escaping (Result<[CKRecord.ID: [DDGProfile]] ,Error>) -> Void) {
        var checkedInProfiles = dict
        let operation = CKQueryOperation(cursor: cursor)
        
        // Stream (function to execute after we fetch each record)
        operation.recordFetchedBlock = {record in
            // Build our dictionary
            guard let checkedInLocationRecordRef = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else { return }
            checkedInProfiles[checkedInLocationRecordRef.recordID, default: []].append(DDGProfile(record: record))
        }
        
        operation.queryCompletionBlock = {cursor, error in
            if let error  {
                completed(.failure(error))
                return
            }
            
            if let cursor {
                self.continueAddingToCheckedInProfilesDict(cursor: cursor, dict: checkedInProfiles){result in
                    switch result {
                    case .success(let profiles):
                        completed(.success(profiles))
                    case .failure(let failure):
                        completed(.failure(failure))
                    }
                }
            }else{
                completed(.success(checkedInProfiles))
            }
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)

    }

    
    func getAllPlacesCheckedInProfilesCount( completed: @escaping (Result<[CKRecord.ID: Int] ,Error>) -> Void) {
        let operation = createGetAllCheckedInProfilesCKOperation()
            
        operation.desiredKeys = [DDGProfile.kIsCheckedIn]
        
        var checkedInProfiles = [CKRecord.ID: Int]()
        
        operation.recordFetchedBlock = { record in
            // Build our dictionary
            guard let checkedInLocationRefID = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else { return }
            checkedInProfiles[checkedInLocationRefID.recordID, default: 0] += 1
        }
        
        operation.queryCompletionBlock = { cursor, error in
            if let error  {
                completed(.failure(error))
                return
            }
            // TODO: Handle Cursor
            completed(.success(checkedInProfiles))
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func fetchRecord(with id: CKRecord.ID, completed: @escaping (Result<CKRecord, Error>) -> Void){
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: id){
            record, error in
            guard let record, error == nil else {
                print(error!.localizedDescription)
                completed(.failure(error!))
                return
            }
            completed(.success(record))
        }
    }
    
    func save(record:CKRecord, completed:@escaping (Result<CKRecord, Error>) -> Void) {
        CKContainer.default().publicCloudDatabase.save(record){
            record, error in
            guard let record, error == nil else {
                completed(.failure(error!))
                return
            }
            completed(.success(record))
        }
    }
}
