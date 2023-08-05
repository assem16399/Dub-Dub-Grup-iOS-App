//
//  PhotoPicker.swift
//  DDG
//
//  Created by Aasem Hany on 26/07/2023.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable{
    @Binding var pickedImage:UIImage
    @Binding var isPhotoPickerDisplayed:Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.allowsEditing = true
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(photoPicker: self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
        let photoPicker:PhotoPicker
        init(photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                photoPicker.pickedImage = image
            }
            photoPicker.isPhotoPickerDisplayed = false
        }
    }
    
}
