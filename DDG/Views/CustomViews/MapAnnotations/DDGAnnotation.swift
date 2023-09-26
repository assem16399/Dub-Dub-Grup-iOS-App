//
//  DDGAnnotation.swift
//  DDG
//
//  Created by Aasem Hany on 04/09/2023.
//

import SwiftUI

struct DDGAnnotation: View {
    let location: DDGLocation
    let profilesCount: Int
    var body: some View {
        VStack{
            ZStack{
                MapBalloon()
                    .frame(width: 100,height: 70)
                    .foregroundColor(.brandPrimary)
                CircularImage(uiImage:location.createImage(for: .square),
                              radius: 20)
                .offset(y:-11)
                if (profilesCount > 0)
                {
                    Text("\(min(profilesCount,99))")
                        .font(.system(size: 11,weight: .bold))
                        .frame(width: 26,height: 18)
                        .background(Color.grubRed)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .offset(x: 20,y: -28)
                }
            }
            Text(location.name)
                .font(.caption)
                .fontWeight(.semibold)
        }

        .accessibilityLabel(
            "Map Pin, \(location.name), \(profilesCount) people checked in.")
    }
}

struct DDGAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        DDGAnnotation(location: DDGLocation(record: MockData.location),profilesCount: 99)
    }
}
