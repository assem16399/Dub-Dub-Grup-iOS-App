//
//  LocationDetailView.swift
//  DDG
//
//  Created by Aasem Hany on 05/07/2023.
//

import SwiftUI

struct LocationDetailsView: View {
    
    
    @ObservedObject var viewModel: LocationDetailsViewModel
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var gridColumns: [GridItem] {
        dynamicTypeSize < .accessibility1 ? [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]: [GridItem(.flexible())]}
    
    var body: some View {
        ZStack {
            VStack{
                BannerImage(uiImage: viewModel.location.createImage(for: .banner))
                
                VStack {
                    AddressView(address: viewModel.location.address)
                    
                    DescriptionView(desc: viewModel.location.description)
                        
                    
                        HStack{
                            Spacer()
                            
                            Button{
                                viewModel.getDirections()
                            } label:{
                                LocationOptionIcon(icon: "location.fill")
                            }.accessibilityLabel(Text("Get directions."))
                            
                            Spacer()
                            
                            Link(destination: URL(string: viewModel.location.websiteURL)!){
                                LocationOptionIcon(icon: "network")
                            }.accessibilityRemoveTraits(.isButton)
                                .accessibilityLabel(Text("Go to website."))
                            
                            Spacer()
                            
                            Button{
                                viewModel.callLocationNumber()
                            } label:{
                                LocationOptionIcon(icon: "phone.fill")
                            }.accessibilityLabel(Text("Call location."))
                            
                            
                            Spacer()
                            
                            if let _ =  CloudKitManager.shared.profileRecordId {
                                Button{
                                    viewModel.changeCheckInStatus()
                                } label:{
                                    LocationOptionIcon(
                                        icon: viewModel.checkInButtonIcon,
                                        bgColor: viewModel.checkInButtonColor)
                                    
                                }.accessibilityLabel(viewModel.checkInButtonA11yLabel)
                                .disabled(viewModel.isLoading)
                                
                                Spacer()
                            }
                            
                        }
                        .padding(.vertical,5)
                        .background( Color(uiColor: .secondarySystemBackground))
                        .clipShape(.capsule)
                        .frame(height: 60)
                    
                        GridHeaderText(peopleCount: viewModel.checkedInProfiles.count)
                    
                }.padding(.horizontal)
                
                VStack{
                    if viewModel.isLoading { CircularLoadingView() }
                    else {
                        if viewModel.checkedInProfiles.isEmpty {
                            GridEmptyStateView()
                        } else {
                            ScrollView {
                                LazyVGrid(columns: gridColumns) {
                                    ForEach(viewModel.checkedInProfiles){
                                        profile in
                                        UserAvatarView(profile: profile)
                                        .onTapGesture{
                                            withAnimation{
                                                viewModel.showDetails(of: profile, in: dynamicTypeSize)
                                            }
                                        }
                                    }
                                }
                            }
                            .listStyle(.plain)
                            .listRowInsets(EdgeInsets())
                            .listSectionSeparator(.hidden)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 0)
            }
            .blur(radius: viewModel.isCheckedInProfileModalDisplayed ? 20 : 0)
            .disabled(viewModel.isCheckedInProfileModalDisplayed)
            
            if viewModel.isCheckedInProfileModalDisplayed{
                ProfileDetailsModalView(
                    isProfileDisplayed: $viewModel.isCheckedInProfileModalDisplayed,
                    profile: viewModel.selectedProfile!)
                
            }
        }
        .onAppear{ viewModel.getCheckedInProfiles() }
        .alert(item: $viewModel.alertItem){ Alert(from: $0) }
        .sheet(isPresented: $viewModel.isCheckedInProfileSheetDisplayed){
            ProfileDetailsSheetView(
                isProfileDisplayed: $viewModel.isCheckedInProfileSheetDisplayed,
                profile: viewModel.selectedProfile!)
        }
        .navigationTitle(viewModel.location.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LocationDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            LocationDetailsView(viewModel: LocationDetailsView.LocationDetailsViewModel(location: DDGLocation(record: MockData.location)))
        }
        
    }
}

struct LocationOptionIcon: View {
    let icon: String
    let bgColor: Color
    
    init(icon: String, bgColor:Color = .brandPrimary) {
        self.icon = icon
        self.bgColor = bgColor
    }
    
    var body: some View {
        ZStack{
            Circle()
                .foregroundColor(bgColor)
            
            Image(systemName: icon)
                .resizable()
                .scaledToFill()
                .frame(width: 25, height: 25)
                .imageScale(.large)
                .foregroundColor(.white)
        }
    }
}

struct UserAvatarView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    let profile: DDGProfile
    
    var body: some View {
        VStack {
            CircularImage(uiImage: profile.avatarImage,
                          radius: dynamicTypeSize >= .accessibility1 ? 100 : 40)
            
            Text(profile.firstName)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(Text("Show's \(profile.firstName) profile popup."))
        .accessibilityLabel(Text("\(profile.firstName) \(profile.lastName)"))
    }
}

struct BannerImage: View {
    let imageName: String?
    let uiImage: UIImage?
    
    init(imageName: String) {
        self.imageName = imageName
        self.uiImage = nil
    }
    
    init(uiImage: UIImage) {
        self.imageName = nil
        self.uiImage = uiImage
    }
    
    var body: some View {
        (imageName == nil
         ? Image(uiImage: uiImage!)
         : Image(imageName!))
        .resizable()
        .scaledToFill()
        .frame(height: 120)
        .padding(.bottom )
        .clipped()
        .accessibilityHidden(true)
        
    }
}

struct AddressView: View {
    let address: String
    var body: some View {
        HStack {
            Label(address, systemImage: "mappin.and.ellipse")
                .font(.caption)
            
            Spacer()
        }.padding(.bottom, 20)
    }
}

struct DescriptionView: View {
    let desc: String
    var body: some View {
        Text(desc)
            .minimumScaleFactor(0.7)
            .padding(.horizontal)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct GridHeaderText: View {
    let peopleCount: Int
    
    var body: some View {
        Text("Who's Here?")
            .font(.title2)
            .bold()
            .padding(.vertical, 20)
            .accessibilityAddTraits(.isHeader)
            .accessibilityLabel(Text("Who's here? \(peopleCount) checked in"))
            .accessibilityHint(Text("Bottom section is scrollable"))
    }
}

struct                         GridEmptyStateView: View {
    var body: some View {
        Text("No one checked in here yet")
            .font(.headline)
            .padding(.top, 30)
    }
}
