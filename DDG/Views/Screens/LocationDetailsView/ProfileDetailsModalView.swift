//
//  ProfileDetails.swift
//  DDG
//
//  Created by Aasem Hany on 13/08/2023.
//

import SwiftUI

struct ProfileDetailsModalView: View {
    @Binding var isProfileDisplayed: Bool
    let profile: DDGProfile
    var body: some View {
        ZStack(alignment: .top){
            CircularImage(uiImage: profile.createAvatarImage(), radius: 50)
                .accessibilityHidden(true)
                .alignmentGuide(VerticalAlignment.top) { $0[VerticalAlignment.center] }
                        .zIndex(1)
                        .shadow(radius: 10)
                        
            VStack{
                Spacer()
                    .frame(height: 60)

                Text("\(profile.firstName) \(profile.lastName)")
                    .font(.title)
                    .lineLimit(1)
                    .bold()
                    .minimumScaleFactor(0.75)
                
                Text("\(profile.companyName)")
                    .accessibilityLabel(Text("Works at, \(profile.companyName)"))
                    .lineLimit(2)
                    .foregroundColor(Color.secondary)
                    .minimumScaleFactor(0.75)

                Spacer()
                    .frame(height: 20)

                Text("\(profile.bio)")
                    .accessibilityLabel(Text("Bio, \(profile.bio)"))
                    .lineLimit(5)

                Spacer()
                    
            }.padding()
            .frame(width: 350,height: 250)
            .background(Color(uiColor: .secondarySystemBackground))

            .cornerRadius(12)
            .shadow(radius: 40)
            .overlay(alignment: .topTrailing, content: {
                Button{
                    withAnimation{
                        isProfileDisplayed.toggle()
                    }
                }label: {
                    XDismissButton()
                }
                .padding()
            })
        
        }
        
    }
}

struct ProfileDetails_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailsModalView(isProfileDisplayed: .constant(true),profile: DDGProfile(record: MockData.profile))
    }
}
