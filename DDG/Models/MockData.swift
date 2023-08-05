//
//  MockData.swift
//  DDG
//
//  Created by Aasem Hany on 05/07/2023.
//

import CloudKit

struct MockData {
    static var location: CKRecord {
        let record = CKRecord(recordType: RecordType.location)
        record[DDGLocation.kName] = "Grace Deli & Cafe"
        record[DDGLocation.kAddress] = "123 Main Street"
        record[DDGLocation.kDescription] = "This a test description This a test description This a test description This a test description"
        record[DDGLocation.kWebsiteURL] = "https://apple.com"
        record[DDGLocation.kLocation] = CLLocation(latitude: 37.331516, longitude: -121.891054)
        record[DDGLocation.kPhoneNumber] = "+201027231201"
        return record
    }
}
