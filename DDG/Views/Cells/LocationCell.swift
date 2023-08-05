//
//  LocationCell.swift
//  DDG
//
//  Created by Aasem Hany on 05/07/2023.
//

import SwiftUI

struct LocationsCell: View {
    let location: DDGLocation
    var body: some View {
        print(location.name)
        print(location.name.count)
        return HStack(spacing: 20){
            CircularImage(uiImage: location.createImage(for: .square), radius: 40)
                .padding(.vertical, 8)
            VStack(alignment: .leading,spacing: 8){
                Text(location.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                
                HStack{
                    ForEach(0..<5){ index in
                        CircularImage(imageName: "default-avatar",radius: 17.5)
                    }
                }
            }
        }
        .listRowSeparatorTint(.brandPrimary)

    }
}


struct LocationsCell_Previews: PreviewProvider {
    static var previews: some View {
        LocationsCell(location: DDGLocation(record: MockData.location))
    }
}
