//
//  View+Ext.swift
//  DDG
//
//  Created by Aasem Hany on 05/07/2023.
//

import SwiftUI


extension View {
    func profileNameTextFieldStyle() -> some View {
        self.modifier(NameTextFieldModifier())
    }
    
    
    
    func embedInScrollView() -> some View {
        GeometryReader{ geometry in
            ScrollView{
                frame(minHeight: geometry.size.height, maxHeight: .infinity)
            }
        }
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

