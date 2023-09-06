//
//  LocationDetailView.swift
//  DDG
//
//  Created by Aasem Hany on 05/07/2023.
//

import SwiftUI

struct LocationDetailsView: View {
    
    
    @ObservedObject var viewModel: LocationDetailsViewModel
    
    let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        ZStack {
            VStack{
                BannerImage(uiImage: viewModel.location.createImage(for: .banner))
                
                VStack {
                    AddressView(address: viewModel.location.address)
                    
                    DescriptionView(desc: viewModel.location.description)
                    
                    ZStack{
                        Color(uiColor: .secondarySystemBackground)
                            .cornerRadius(50)
                        
                        HStack{
                            Spacer()
                            
                            Button{
                                viewModel.getDirections()
                            } label:{ LocationOptionIcon(icon: "location.fill") }
                            
                            Spacer()
                            
                            Link(destination: URL(string: viewModel.location.websiteURL)!,
                                 label:{ LocationOptionIcon(icon: "network") })
                            
                            Spacer()
                            
                            Button{
                                viewModel.callLocationNumber()
                            } label:{ LocationOptionIcon(icon: "phone.fill") }
                            
                            Spacer()
                            
                            if let _ =  CloudKitManager.shared.profileRecordId {
                                Button{
                                    if viewModel.isLoading { return }
                                    viewModel.changeCheckInStatus(to: viewModel.isUserCheckedIn ? .checkedOut : .checkedIn)
                                } label:{
                                    if viewModel.isLoading {
                                        ProgressView()
                                            .tint(.brandPrimary)
                                            .scaleEffect(2)
                                    }else {
                                        LocationOptionIcon(
                                            icon: viewModel.isUserCheckedIn
                                            ? "person.fill.xmark"
                                            : "person.fill.checkmark",
                                            bgColor: viewModel.isUserCheckedIn
                                            ? .grubRed
                                            : .brandPrimary)
                                    }
                                }
                                Spacer()
                            }
                            
                        }
                    }
                    .frame(height: 80)
                    
                    Text("Who's Here?")
                        .font(.title2)
                        .bold()
                        .padding(.vertical, 20)
                    
                }.padding(.horizontal)
                
                VStack{
                    if viewModel.isLoading { CircularLoadingView() }else{
                        if viewModel.checkedInProfiles.isEmpty {
                            Text("No one checked in here yet")
                                .font(.headline)
                                .padding(.top, 30)
                        }
                        else{
                            List {
                                LazyVGrid(columns: gridColumns) {
                                    ForEach(viewModel.checkedInProfiles){
                                        profile in
                                        UserAvatarView(
                                            name: profile.firstName,
                                            image: profile.createAvatarImage())
                                        .onTapGesture{
                                            withAnimation{
                                                viewModel.isCheckedInProfileDisplayed = true
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
                
                Spacer()
            }
            .navigationTitle(viewModel.location.name)
            .navigationBarTitleDisplayMode(.inline)
            // Uncomment if you are using a sheet to display location details
            //            .toolbar{
            //                ToolbarItem(placement: .navigationBarTrailing){
            //                    Button{}label: {
            //                        Text("Dismiss")
            //                            .foregroundColor(.red)
            //                    }
            //                }
            //            }
            .alert(item: $viewModel.alertItem){ alert in
                Alert(title: alert.title,message: alert.message,dismissButton: alert.dismissButton)
            }
            .blur(radius: viewModel.isCheckedInProfileDisplayed ? 20 : 0)
            .disabled(viewModel.isCheckedInProfileDisplayed)
            if viewModel.isCheckedInProfileDisplayed {
                ProfileDetailsView(isProfileDisplayed: $viewModel.isCheckedInProfileDisplayed,profile: DDGProfile(record: MockData.profile))
                    .transition(.slide)
                    .zIndex(1)
            }
        }.onAppear{ viewModel.getCheckedInProfiles() }
    }
}

struct LocationDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailsView(viewModel: LocationDetailsViewModel(location: DDGLocation(record: MockData.location)))
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
                .padding(.vertical, 10)
            
            Image(systemName: icon)
                .scaledToFit()
                .imageScale(.large)
                .foregroundColor(.white)
        }
    }
}

struct UserAvatarView: View {
    let name: String
    let image: UIImage
    var body: some View {
        VStack {
            CircularImage(uiImage: image, radius: 40)
            
            Text(name)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
        }
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
            .lineLimit(3)
            .padding(.bottom, 20)
    }
}
