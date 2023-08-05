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
                print(self.userRecord)
            }
        }
    }
    func getLocations(comleted: @escaping (Result<[DDGLocation],Error>)-> Void){
        let sortDescriptor = NSSortDescriptor(key: DDGLocation.kName, ascending: true)
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        query.sortDescriptors = [sortDescriptor]
        
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil){
            records, error in
            guard error == nil else{
                comleted(.failure(error!))
                return
            }
            
            guard let records else { return }
            
            let locations = records.map{DDGLocation(record: $0)}
            comleted(.success(locations))
        }
    }
    
    func creatProfileOperation(records:[CKRecord], completed: @escaping (Result<[CKRecord],Error>) -> Void) {
         
        // Create a CKOperation to save our User and Profile Records using patch save
        let operation = CKModifyRecordsOperation(recordsToSave: records)
//                operation.modifyRecordsResultBlock = {result in
//                    switch result {
//                    case .success():
//                        print("Saved")
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//
//                }
        operation.modifyRecordsCompletionBlock = {savedRecords, _ , error in
            guard let savedRecords, error == nil else {
                print(error!.localizedDescription)
                completed(.failure(error!))
                return
            }
            completed(.success(savedRecords))
            print(savedRecords)
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
