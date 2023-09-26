//
//  LogoView.swift
//  DDG
//
//  Created by Aasem Hany on 25/07/2023.
//

import SwiftUI

struct LogoView: View {
    let height: CGFloat
    var body: some View {
        Image(decorative: "ddg-map-logo")
            .resizable()
            .scaledToFit()
            .frame(height: height)
            
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView(height: 70)
    }
}
