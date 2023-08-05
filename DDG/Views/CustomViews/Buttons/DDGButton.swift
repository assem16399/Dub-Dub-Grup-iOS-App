//
//  DDGButton.swift
//  DDG
//
//  Created by Aasem Hany on 05/07/2023.
//

import SwiftUI

struct DDGButton: View {
    let title: String
    let onPressed: () -> Void
    
    var body: some View {
        Button(action: onPressed){
            Text(title)
                .bold()
                .frame(width: 240)
        }.buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(.brandPrimary)
    }
}


struct DDGButton_Previews: PreviewProvider {
    static var previews: some View {
        DDGButton(title: "Save Profile"){}
    }
}
