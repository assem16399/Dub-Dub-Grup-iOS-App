//
//  CKAssets+Ext.swift
//  DDG
//
//  Created by Aasem Hany on 17/07/2023.
//

import CloudKit
import UIKit

extension CKAsset{
    func convertToUIImage(in dimension: ImageDimension) -> UIImage {
        let placeHolder = dimension.placeHolder
        
        guard let fileURL else { return placeHolder }
        
        do{
            let data = try Data(contentsOf: fileURL)
            return UIImage(data: data) ?? placeHolder
        }
        catch{
            print(error)
            return placeHolder
        }
    }
}
