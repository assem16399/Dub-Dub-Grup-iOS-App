//
//  ProfileDetailsSheetView.swift
//  DDG
//
//  Created by Aasem Hany on 20/09/2023.
//

import SwiftUI

struct ProfileDetailsSheetView: View {
    @Binding var isProfileDisplayed: Bool
    let profile: DDGProfile
    var body: some View {
        NavigationStack
        {
            ScrollView {
                VStack{
                    CircularImage(uiImage: profile.avatarImage, radius: 50)
                        .accessibilityHidden(true)
                    
                    Text("\(profile.firstName) \(profile.lastName)")
                        .font(.title)
                        .bold()
                        .minimumScaleFactor(0.9)
                        .multilineTextAlignment(.center)

                    Spacer().frame(height: 20)

                    Text("\(profile.companyName)")
                        .accessibilityLabel(Text("Works at, \(profile.companyName)"))
                        .foregroundColor(Color.secondary)
                        .minimumScaleFactor(0.9)
                        .multilineTextAlignment(.center)

                    Spacer().frame(height: 20)
                    
                    Text("\(profile.bio)")
                        .accessibilityLabel(Text("Bio, \(profile.bio)"))
                        .multilineTextAlignment(.center)
                    
                    
                }.padding()
            }
            .toolbar{
                Button("Dismiss"){ isProfileDisplayed = false}
            }
        }

    }
}

struct ProfileDetailsSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailsSheetView(isProfileDisplayed: .constant(true), profile: DDGProfile(record: MockData.profile))
    }
}
