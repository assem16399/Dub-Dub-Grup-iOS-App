//
//  LocationCell.swift
//  DDG
//
//  Created by Aasem Hany on 05/07/2023.
//

import SwiftUI

struct LocationsCell: View {
    let location: DDGLocation
    let checkedInProfiles: [DDGProfile]
    
    
    var body: some View {
        HStack(spacing: 20){
            CircularImage(uiImage: location.createImage(for: .square), radius: 40)
                .padding(.vertical, 8)
            
            VStack(alignment: .leading,spacing: 8){
                Text(location.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                
                    if checkedInProfiles.isEmpty {
                        Text("Nobody's Checked In")
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                    else {
                        CheckedInUsersListView(checkedInProfiles: checkedInProfiles)
                    }
            }
        }
        .listRowSeparatorTint(.brandPrimary)
        
    }
}


struct LocationsCell_Previews: PreviewProvider {
    static var previews: some View {
        LocationsCell(location: DDGLocation(record: MockData.location),checkedInProfiles: [])
    }
}

struct CheckedInUsersListView: View {
    let checkedInProfiles:[DDGProfile]
    
    var body: some View {
        HStack {
            
            ForEach(checkedInProfiles.indices, id: \.self){ index in
                if index <= 3 {
                    CircularImage(uiImage: checkedInProfiles[index].createAvatarImage(),radius: 17.5)

                    
                } else if index == 4 {
                    AdditionalCheckedInUsersCountView(uiImage: checkedInProfiles[index].createAvatarImage(), additionalUsersCount: checkedInProfiles.count - index)
                }
            }
        }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct AdditionalCheckedInUsersCountView: View {
    let uiImage: UIImage
    let additionalUsersCount: Int
    
    var body: some View{
        ZStack {
            CircularImage(uiImage: uiImage, radius: 17.5)
                .opacity(0.8)
            
            Text("+\(formattedAdditionalUserCount())")
                .font(.system(size: 16))
                .foregroundColor(.brandSecondary)
        }
    }
    
    private func formattedAdditionalUserCount() -> Int {
        additionalUsersCount > 99 ? 99 : additionalUsersCount
    }
}
 
