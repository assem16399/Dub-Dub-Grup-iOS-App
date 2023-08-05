//
//  XDismissButton.swift
//  DDG
//
//  Created by Aasem Hany on 26/07/2023.
//

import SwiftUI

struct XDismissButton: View {
    var body: some View {
        ZStack{
            
            Circle()
                .frame(width: 35)
                .foregroundColor(Color.brandPrimary)
            
            Image(systemName: "xmark")
                .foregroundColor(Color(uiColor: .white))
            
        }
    }
}

struct XDismissButton_Previews: PreviewProvider {
    static var previews: some View {
        XDismissButton()
    }
}
