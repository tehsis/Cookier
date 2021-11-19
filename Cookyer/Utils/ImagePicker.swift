//
//  ImagePicker.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/18/21.
//

import Foundation

import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .camera
    
    @Binding var selectedImage: UIImage
    @Environment(\.presentationMode) var presentationMode
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var parent: ImagePicker
    
    init (_ parent: ImagePicker) {
        self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            parent.selectedImage = image
        }
        
        parent.presentationMode.wrappedValue.dismiss()
    }
}
