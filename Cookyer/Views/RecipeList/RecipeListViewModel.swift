//
//  RecipeListViewModel.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/17/21.
//

import Foundation

final class RecipeListViewModel: ObservableObject {
    @Published var viewingRecipe = false
    @Published var addRecipeActive = false
    @Published var showingSearch = false
    @Published var shouldOnlyUseTheseIngredients = false
    
    @Published var recipeIndex = 0
    @Published var selectedFilters: [Ingredient] = []
    @Published var filteredRecipes: [Recipe] = []
    
    
    var currentRecipe: Recipe {
        filteredRecipes[recipeIndex]
    }
    
    func moveToNextRecipe() {
        recipeIndex = recipeIndex + 1
        
        if recipeIndex >= filteredRecipes.count {
            recipeIndex = 0
        }
    }
    
    func showRecipe() {
        viewingRecipe = true
    }
    
    func showSearch() {
        showingSearch = true
    }
    
    func updateFilter(recipes: [Recipe]) {
        recipeIndex = 0
        if selectedFilters.isEmpty {
            filteredRecipes = recipes.shuffled()
        } else {
            if shouldOnlyUseTheseIngredients {
                filteredRecipes = recipes.filter { exclusiveFilter(recipe: $0) }
            } else {
                filteredRecipes = recipes.filter { inclusiveFilter(recipe: $0) }

            }
        }
         
    }
    
    func inclusiveFilter(recipe: Recipe) -> Bool {
        let filteredIngredients = recipe.ingredientsSet.filter { recipe_ingredient in
            if let ingredient = recipe_ingredient.usesIngredient {
                return selectedFilters.contains(ingredient)
            }
            
            return false
        }
        
        return !filteredIngredients.isEmpty
    }
    
    func exclusiveFilter(recipe: Recipe) -> Bool {
        let filteredIngredients = recipe.ingredientsSet.filter { recipe_ingredient in
            guard let ingredient = recipe_ingredient.usesIngredient else {
                return false
            }
            
            if !selectedFilters.contains(ingredient) {
                return false
            }
            
            
            return true
        }
        
        return filteredIngredients.count > 0
            && recipe.ingredientsSet.count == filteredIngredients.count
    }
}
