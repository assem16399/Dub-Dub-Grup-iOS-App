//
//  AppTabView.swift
//  DDG
//
//  Created by Aasem Hany on 05/07/2023.
//

import SwiftUI

struct AppTabView: View {
    
    var body: some View {
        TabView{
            LocationMapView()
                .tabItem{ Label("Map", systemImage: "map") }
            
            LocationsListView()
                .tabItem{ Label("Locations", systemImage: "list.clipboard.fill") }
            
            NavigationStack {
                ProfileView()
            }
            .tabItem{ Label("Profile", systemImage: "person")
            }
        }
        .onAppear{
            
            CloudKitManager.shared.getUserRecord()
            let appearance = UITabBarAppearance()
            
            appearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterialDark)
            
            // Use this appearance when scrolling behind the TabView:
            UITabBar.appearance().standardAppearance = appearance
            // Use this appearance when scrolled all the way up:
            UITabBar.appearance().scrollEdgeAppearance = appearance
            
            UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        }
        .tint(.brandPrimary)
        
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
