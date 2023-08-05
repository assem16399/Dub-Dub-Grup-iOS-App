//
//  OnBoardingView.swift
//  DDG
//
//  Created by Aasem Hany on 19/07/2023.
//

import SwiftUI

struct OnBoardingView: View {
    @Binding var isOnBoardingDisplayed: Bool
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button{
                    isOnBoardingDisplayed = false
                }label: {
                    XDismissButton()
                }
            }
            .padding()
            Spacer()
            LogoView(height: 155).shadow(radius: 10)
            
            VStack(alignment:.leading, spacing:20){
                
                OnBoardingTile(
                    sfSymbol: "building.2.crop.circle",
                    title: "Restaurant Locations",
                    subtitle: "Find places tp dine around the convention cemter"
                )
                
                OnBoardingTile(
                    sfSymbol: "checkmark.circle",
                    title: "Check In",
                    subtitle: "Let other iOS Devs know where your are"
                )
                
                OnBoardingTile(
                    sfSymbol: "person.2.circle",
                    title: "Find Friends",
                    subtitle: "See Where other iOS Devs are and join the party"
                )
                
            }
            .padding(.horizontal,50)
            
            Spacer()
            
        }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView(isOnBoardingDisplayed: .constant(true))
    }
}

struct OnBoardingTile: View {
    let sfSymbol: String
    let title: String
    let subtitle: String
    var body: some View {
        HStack(spacing: 20){
            
            Image(systemName: sfSymbol)
                .resizable()
                .scaledToFit()
                .frame(width: 50,height: 50)
                .foregroundColor(.brandPrimary)
            
            VStack(alignment: .leading){
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(uiColor: .label))
                
                Text(subtitle)
                
            }
            
        }
    }
}

