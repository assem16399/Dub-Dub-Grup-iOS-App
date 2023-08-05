//
//  CustomModifiers.swift
//  DDG
//
//  Created by Aasem Hany on 05/07/2023.
//

import SwiftUI

struct NameTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .autocorrectionDisabled()
            .lineLimit(1)
            .minimumScaleFactor(0.75)
            .font(.system(size: 32 ,weight: .bold, design: .default))
    }
}
