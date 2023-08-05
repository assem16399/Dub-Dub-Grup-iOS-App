//
//  UIImage+Ext.swift
//  DDG
//
//  Created by Aasem Hany on 27/07/2023.
//

import CloudKit
import UIKit

extension UIImage{
    func convertToCKAsset() -> CKAsset? {
        // Get apps base document dir url
        guard let urlPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Document Dir is nil")
            return nil
        }
        
        // Append some unique identifier for our profile image
        let fileURL = urlPath.appendingPathComponent("selectedAvatarImage")
        
        // Write the image data after compression to the location address points to it
        guard let jpegData = jpegData(compressionQuality: 0.25) else{ return nil }
        guard let _ = try? jpegData.write(to: fileURL) else{ return nil }

        // Create our CKAsset with that FileURL and return it
        return CKAsset(fileURL: fileURL)
    }
}
