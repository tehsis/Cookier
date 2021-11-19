//
//  AddRecipeViewModel.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/18/21.
//

import Foundation
import CoreData
import SwiftUI

class AddRecipeViewModel: ObservableObject {
    struct _Ingredient: RecipeIngredients, Hashable {
        var ingredientName: String
        var quantity: Int16
        var unitString: String
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Published var shouldPresentSourceDialog = false
    @Published var isShowingCamera = false
    @Published var isShowingLibrary = false
    
    @Published var newProcedure = ""
    @Published var newRecipeName = ""
    @Published var newPhoto = UIImage()
    @Published var newIngredient = _Ingredient(ingredientName: "", quantity: 0, unitString: "")
    
    @Published var quantityString = "" {
        didSet {
            let filtered = quantityString.filter { $0.isNumber }
            
            if quantityString != filtered {
                quantityString = filtered
            }
            
            newIngredient.quantity = Int16(quantityString) ?? 0
        }
    }
    
    @Published var ingredients: [_Ingredient] = []
    
    func addNewIngredient() {
        ingredients.append(newIngredient)
        newIngredient.ingredientName = ""
        newIngredient.unitString = ""
        newIngredient.quantity = 0
        quantityString = ""
    }
    
    func takePicture() {
        shouldPresentSourceDialog = true
    }
    
    func uploadRecipe() {
        
    }
}
