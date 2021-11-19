//
//  ActivityView.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/18/21.
//

import Foundation

import UIKit
import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    
    let data: [Any]
    
    func makeUIViewController(context: Context) -> some UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        let activityViewController = UIActivityViewController(activityItems: data, applicationActivities: nil)
        
        if isPresented && uiViewController.presentedViewController == nil {
            uiViewController.present(activityViewController, animated: true)
        }
        
        activityViewController.completionWithItemsHandler = { (_, _, _, _) in
            isPresented = false
        }
    }
    
    
}
