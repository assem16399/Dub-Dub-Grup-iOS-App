//
//  AlertItem.swift
//  DDG
//
//  Created by Aasem Hany on 09/07/2023.
//

import SwiftUI


struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    //MARK: - MapView Alerts
    static let unableToGetLocations = AlertItem(title: Text("Locations Error"),
                                                message: Text("Unable to retrieve locations at this time"),
                                                dismissButton: .default(Text("Okay")))
    
    
    static let locationRestricted = AlertItem(title: Text("Locations Restricted"),
                                                message: Text("Your location is restricted. This may due parental control."),
                                                dismissButton: .default(Text("Okay")))
    
    static let locationDenied = AlertItem(title: Text("Locations Denied"),
                                                message: Text("Dub Dub Grub does not have permission to access your location. To change that go to your phone Settings -> Dub Dub Grub -> Location"),
                                                dismissButton: .default(Text("Okay")))
    
    static let locationDisabled = AlertItem(title: Text("Locations Disabled"),
                                                message: Text("Your phone location services are disabled. To change that go to your phone Settings -> Privacy -> Location Services"),
                                                dismissButton: .default(Text("Okay")))
    
    //MARK: - ProfileView Alerts

    static let profileNotValid = AlertItem(title: Text("Profile Not Valid"),
                                                message: Text("Your avatar image, all other fields are required and bio shouldn't be more than 300 characters. \nPlease try again."),
                                                dismissButton: .default(Text("Okay")))
    
    static let noUserRecord = AlertItem(title: Text("No User Record"),
                                                message: Text("You must log into iCloud on your phone in order to utilize DubDubGrub's Profile. Please login on your phone settings screen."),
                                                dismissButton: .default(Text("Okay")))
    
    static let profileCreatedSuccessfully = AlertItem(title: Text("Profile Created Successfully!"),
                                                message: Text("Your Profile has been created successfully"),
                                                dismissButton: .default(Text("Okay")))
    
    static let failedToCreateProfile = AlertItem(title: Text("Failed to Create Profile!"),
                                                message: Text("We were unable to create profile this time. \nPlease try again later."),
                                                dismissButton: .default(Text("Okay")))
    
    static let failedToRetrieveProfile = AlertItem(title: Text("Failed to Retrieve Profile!"),
                                                message: Text("We were unable to retrieve your profile this time. \nPlease try again later."),
                                                dismissButton: .default(Text("Okay")))
    
    static let profileUpdatedSuccessfully = AlertItem(title: Text("Profile Updated Successfully!"),
                                                message: Text("Your profile has been updated successfully."),
                                                dismissButton: .default(Text("Okay")))
    
    static let failedToUpdateProfile = AlertItem(title: Text("Failed to Update!"),
                                                message: Text("Unable to update your profile. \nPlease try agian later."),
                                                dismissButton: .default(Text("Okay")))
    
    //MARK: - LocationDetails Alerts
    static let invalidPhoneNumber = AlertItem(title: Text("Invalid Phone Number"),
                                                message: Text("The phone number for the location is invalid."),
                                                dismissButton: .default(Text("Okay")))

    //MARK: - LocationDetails Alerts
    static let invalidDevice = AlertItem(title: Text("Invalid Device"),
                                                message: Text("The device you're are using is not supported."),
                                                dismissButton: .default(Text("Okay")))

}
