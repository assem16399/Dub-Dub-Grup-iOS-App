//
//  ProfileView.swift
//  DDG
//
//  Created by Aasem Hany on 05/07/2023.
//

import SwiftUI
import CloudKit

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    var body: some View {
        ZStack{
            VStack{
                ZStack{
                    Color(uiColor: .secondarySystemBackground)
                        .cornerRadius(12)
                    
                    HStack(spacing: 8){
                        Button{ viewModel.isShowingPhotoPicker = true } label: {
                            ZStack {
                                CircularImage(uiImage:viewModel.avatar, radius: 45)
                                
                                ProfileImageEditIcon()
                            }
                        }
                        
                        VStack(alignment: .leading,spacing: 0){
                            TextField("FirstName", text: $viewModel.firstName)
                                .profileNameTextFieldStyle()
                            
                            TextField("Last Name", text: $viewModel.lastName)
                                .profileNameTextFieldStyle()
                            
                            TextField("Job", text: $viewModel.job)
                                .autocorrectionDisabled()
                                .minimumScaleFactor(0.75)
                        }
                        .padding(.trailing)
                    }
                    .padding()
                }
                .frame( height: 130)
                
                VStack{
                    HStack{
                        RemainedCharactersView(remainsChars: viewModel.remainsChars)
                        
                        Spacer()
                        
                        Button{}label: {
                            Label("Check Out", systemImage: "mappin.and.ellipse")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color(uiColor: .systemRed))
                    }
                    
                    UserBioView(userBio: $viewModel.userBio)
                }
                .padding(.horizontal, 5)
                
                Spacer()
                
                DDGButton(title: viewModel.profileContext == .create
                          ? "Create Profile"
                          : "Update Profile")
                {
                    viewModel.profileContext == .create
                    ? viewModel.createProfile()
                    : viewModel.updateProfile()
                }
            }
            .padding()
            
            if viewModel.isLoading{
                CirculalLoadingView()
            }
        }
        
        .navigationTitle("Profile")
        .toolbar{
            ToolbarItem(placement: .keyboard){
                Button{
                    dismissKeyboard()
                }label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
        }
        .onAppear{
            viewModel.getProfile()
        }
        .alert(item: $viewModel.alertItem){alert in
            Alert(title: alert.title,
                  message: alert.message,
                  dismissButton: alert.dismissButton
            )
        }
        .sheet(isPresented: $viewModel.isShowingPhotoPicker){
            PhotoPicker(pickedImage: $viewModel.avatar,
                        isPhotoPickerDisplayed: $viewModel.isShowingPhotoPicker)
        }
    }
    
    
    
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ProfileView()
        }
    }
}

struct RemainedCharactersView: View {
    let remainsChars:Int
    var body: some View{
        Text("Bio ")
        +
        Text("\(remainsChars)")
            .bold()
            .foregroundColor(remainsChars < 0 ? Color(uiColor: .systemPink) : .brandPrimary )
        +
        Text(" characters remain")
    }
}

struct ProfileImageEditIcon: View {
    var body: some View {
        Image(systemName: "square.and.pencil")
            .resizable()
            .scaledToFit()
            .frame(width: 14,height: 14)
            .foregroundColor(.white)
            .padding(.bottom)
            .offset(x: 0,y: 40)
    }
}


struct UserBioView: View {
    @Binding var userBio: String
    var body: some View {
        TextEditor(text: $userBio)
            .autocorrectionDisabled(true)
            .frame(height: 100)
            .padding(.vertical,5)
            .padding(.horizontal)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.secondary, lineWidth: 1)
            )
    }
}
