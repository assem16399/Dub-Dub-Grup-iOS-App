//
//  Constants.swift
//  DDG
//
//  Created by Aasem Hany on 05/07/2023.
//

import UIKit

enum RecordType{
    static let location = "DDGLocation"
    static let profile = "DDGProfile"
}

enum PlaceHolderImage{
    static let avatar = UIImage(named: "default-avatar")!
    static let square = UIImage(named: "default-square-asset")!
    static let banner = UIImage(named: "default-banner-asset")!
}
 
enum ImageDimension {
    case square, banner
    
    var placeHolder: UIImage {
        return self == .square ? PlaceHolderImage.square : PlaceHolderImage.banner
    }
}
