//
//  DDGLocation.swift
//  DDG
//
//  Created by Aasem Hany on 05/07/2023.
//

import CloudKit
import UIKit

struct DDGLocation: Identifiable, Hashable {
    
    static let kName = "name"
    static let kDescription = "description"
    static let kSquareAsset = "squareAsset"
    static let kBannerAsset = "bannerAsset"
    static let kAddress = "address"
    static let kLocation = "location"
    static let kWebsiteURL = "websiteURL"
    static let kPhoneNumber = "phoneNumber"
    
    // The referenced id when we create DDGProfile object
    let id: CKRecord.ID
    let name: String
    let description: String
    let squareAsset: CKAsset!
    let bannerAsset: CKAsset!
    let address: String
    let location: CLLocation
    let websiteURL: String
    let phoneNumber: String
    
    init(record: CKRecord) {
        id = record.recordID
        name = record[DDGLocation.kName] as? String ?? "N/A"
        description = record[DDGLocation.kDescription] as? String ?? "N/A"
        squareAsset = record[DDGLocation.kSquareAsset] as? CKAsset
        bannerAsset = record[DDGLocation.kBannerAsset] as? CKAsset
        address = record[DDGLocation.kAddress] as? String ?? "N/A"
        location = record[DDGLocation.kLocation] as? CLLocation ?? CLLocation(latitude: 0, longitude: 0)
        websiteURL = record[DDGLocation.kWebsiteURL] as? String ?? "N/A"
        phoneNumber = record[DDGLocation.kPhoneNumber] as? String ?? "N/A"
    }
    
    func createImage(for dimension: ImageDimension) -> UIImage {
        guard let bannerAsset else {
            return dimension.placeHolder
        }
        return bannerAsset.convertToUIImage(in: dimension)
        
    }
}
