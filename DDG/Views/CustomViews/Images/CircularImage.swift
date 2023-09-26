//
//  CircularImage.swift
//  DDG
//
//  Created by Aasem Hany on 05/07/2023.
//

import SwiftUI
import UIKit

struct CircularImage: View{
    
    let imageName: String?
    let radius: CGFloat
    let uiImage: UIImage?
    
    
    init(imageName: String, radius: CGFloat) {
        self.imageName = imageName
        self.radius = radius
        self.uiImage = nil
    }
    init(uiImage: UIImage, radius: CGFloat) {
        self.imageName = nil
        self.radius = radius
        self.uiImage = uiImage
    }
    var body: some View {
        (uiImage == nil
            ? Image(imageName!)
            : Image(uiImage: uiImage!))
            .resizable()
            .scaledToFill()
            .frame(width: radius * 2 ,height: radius * 2)
            .clipShape(Circle())
    }
}


struct CircularImage_Previews: PreviewProvider {
    static var previews: some View {
        CircularImage(
        imageName: "default-avatar", radius: 40)
    }
}
