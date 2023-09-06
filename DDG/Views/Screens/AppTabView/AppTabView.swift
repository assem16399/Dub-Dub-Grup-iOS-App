//
//  AppTabView.swift
//  DDG
//
//  Created by Aasem Hany on 05/07/2023.
//

import SwiftUI

struct AppTabView: View {
    @ObservedObject private var viewModel = AppTabViewModel()
    
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
            configTabBarAppearance()
            CloudKitManager.shared.getUserRecord()
            viewModel.runStartupChecks()
        }
        .tint(.brandPrimary)
        .sheet(isPresented: $viewModel.isOnBoardingDisplayed,
               onDismiss:viewModel.checkIfLocationServicesIsEnabled)
        {
            OnBoardingView(isOnBoardingDisplayed: $viewModel.isOnBoardingDisplayed)
        }
    }
    
    private func configTabBarAppearance(){
        let appearance = UITabBarAppearance()
        
        appearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterialDark)
        
        // Use this appearance when scrolling behind the TabView:
        UITabBar.appearance().standardAppearance = appearance
        // Use this appearance when scrolled all the way up:
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
}


struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
