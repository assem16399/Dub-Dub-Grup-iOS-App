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
                ScrollView{
                    HStack(spacing: 8){
                        
                        Button{ viewModel.isShowingPhotoPicker = true } label: {
                            ProfileImagePickerView(uiImage: viewModel.avatar)
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
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                    .frame(height: 130)
                    .padding(.bottom)
                    
                    VStack{
                        HStack{
                            RemainedCharactersView(remainsChars: viewModel.remainsChars)
                                .accessibilityAddTraits(.isHeader)
                            
                            Spacer()
                            
                            if viewModel.isUserCheckedIn
                            {
                                Button{
                                    viewModel.checkOut()
                                }label: {
                                    Label("Check Out", systemImage: "mappin.and.ellipse")
                                }
                                .accessibilityLabel("Check out of current location")
                                .buttonStyle(.borderedProminent)
                                .tint(Color(uiColor: .systemRed))
                            }
                        }
                        
                        UserBioView(userBio: $viewModel.userBio)
                            
                    }
                    .padding(.horizontal, 5)
                    
                    Spacer()
                    
                }

                
                Spacer()
                
                DDGButton(title: viewModel.submitButtonTitle){
                    viewModel.onSubmitButtonPressed()
                }
            }
            .padding()
            
            if viewModel.isLoading{
                CircularLoadingView()
            }
        }
        .navigationTitle("Profile")
        .onAppear{
            viewModel.getProfile()
        }
        .alert(item: $viewModel.alertItem){ Alert(from: $0) }
        .sheet(isPresented: $viewModel.isShowingPhotoPicker){
            PhotoPicker(pickedImage: $viewModel.avatar,
                        isPhotoPickerDisplayed: $viewModel.isShowingPhotoPicker)
        }
        .toolbar{
            ToolbarItem(){
                Button{
                    dismissKeyboard()
                }label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
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

fileprivate struct ProfileImageEditIcon: View {
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

fileprivate struct RemainedCharactersView: View {
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

fileprivate struct UserBioView: View {
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
            .accessibilityLabel(Text("Bio"))
            .accessibilityHint(Text("This text field has a 300 character maximum."))
    }
}

fileprivate struct ProfileImagePickerView: View {
    let uiImage: UIImage
    var body: some View {
        ZStack {
            CircularImage(uiImage: uiImage, radius: 45)
            ProfileImageEditIcon()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(Text("Profile Photo"))
        .accessibilityHint(Text("Opens iPhone photo picker"))
    }
}
