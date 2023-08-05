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
                        } label:{
                            LocationOptionIcon(icon: "phone.fill") }
                        
                        Spacer()
                        
                        Button{} label:{
                            LocationOptionIcon(icon: "person.fill.xmark",bgColor: .red) }
                        
                        Spacer()
                    }
                }
                .frame(height: 80)
                
                Text("Who's Here?")
                    .font(.title2)
                    .bold()
                    .padding(.vertical, 20)
                
            }.padding(.horizontal)
            
            List {
                LazyVGrid(columns: gridColumns) {
                    UserAvatarView()
                    UserAvatarView()
                    UserAvatarView()
                    UserAvatarView()
                    UserAvatarView()
                    UserAvatarView()
                    UserAvatarView()
                    UserAvatarView()
                    UserAvatarView()
                    UserAvatarView()
                }
            }
            .listStyle(.plain)
        }
        .listRowInsets(EdgeInsets())
        .listSectionSeparator(.hidden)
        .navigationTitle(viewModel.location.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Button{}label: {
                    Text("Dismiss")
                        .foregroundColor(.red)
                }
            }
        }
        .alert(item: $viewModel.alertItem){ alert in
            Alert(title: alert.title,message: alert.message,dismissButton: alert.dismissButton)
        }
        
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
    var body: some View {
        VStack {
            CircularImage(imageName: "default-avatar", radius: 40)
            
            Text("Aasem")
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
