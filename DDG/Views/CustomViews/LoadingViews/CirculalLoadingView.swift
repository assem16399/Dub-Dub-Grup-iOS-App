//
//  circulal_loading_view.swift
//  DDG
//
//  Created by Aasem Hany on 01/08/2023.
//

import SwiftUI

struct CirculalLoadingView: View {
    var body: some View {
        ZStack{
            Color(.systemBackground)
                .opacity(0.9)
                .ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.brandPrimary)
                .scaleEffect(2)
                .offset(y:-40)
        }
    }
}

struct circulal_loading_view_Previews: PreviewProvider {
    static var previews: some View {
        CirculalLoadingView()
    }
}
