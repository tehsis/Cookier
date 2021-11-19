//
//  RecipeViewModel.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/18/21.
//

import Foundation
 
class RecipeViewModel: ObservableObject {
    @Published var showingActivityView = false
    
    func showActivityView() {
        showingActivityView = true
    }
}
