//
//  Recipe+Extensions.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/4/21.
//

import CoreData
import SwiftUI

class Recipe: NSManagedObject, Decodable {
    
    // MARK: Helpers for CoreData
    var nameString: String {
        name ?? ""
    }
    
    var procedureString: String {
        procedure ?? ""
    }
    
    var ingredientsSet: [Recipe_Ingredients] {
        hasManyIngredients?.allObjects as? [Recipe_Ingredients] ?? []
    }
    
    var ingredientsString: String {
        ingredientsSet.map { ingredient in
            "\(ingredient.quantity) \(ingredient.unitString) \(ingredient.ingredientName)"
        }.joined(separator: "\n")
    }
    
    var photosSet: Set<Photo> {
        hasManyPhotos as? Set<Photo> ?? Set<Photo>()
    }
    
    var cachedImage: Image?
    
    convenience init(context: NSManagedObjectContext, name: String, procedure: String, id: UUID = UUID()) {
        self.init(context: context)
        self.name = name
        self.procedure = procedure
        self.id = id
    }
    
    // MARK: Decoder
    enum CodingKeys: CodingKey {
        case id, name, procedure, Ingredients, Photos
    }
    
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManageObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.procedure = try container.decode(String.self, forKey: .procedure)
        let photos = try container.decode(Set<Photo>.self, forKey: .Photos)
        self.addToHasManyPhotos(NSMutableSet(set: photos))
        
        let ingredientsApi = try container.decode(Set<_IngredientAPI>.self, forKey: .Ingredients)
        
        ingredientsApi.forEach { ingredientApi in
            let ingredient = Ingredient(context: context, id: ingredientApi.id, name: ingredientApi.name)
            let RecipeIngredient = Recipe_Ingredients(context: context, recipe: self, ingredient: ingredient, quantity: Int16(ingredientApi.RecipeIngredients.quantity), unit: ingredientApi.RecipeIngredients.unit, recipeID: self.id!, ingredientID: ingredientApi.id)
            self.addToHasManyIngredients(RecipeIngredient)
        }
    }
    

    // helper class to decode Ingredients from API
    struct _IngredientAPI: Decodable, Hashable, Identifiable {
        static func == (lhs: Recipe._IngredientAPI, rhs: Recipe._IngredientAPI) -> Bool {
            return  lhs.id == rhs.id
        }
        
        enum codingKeys: CodingKey {
            case id, name, RecipeIngredients
        }
        
        let id: UUID
        let name: String
        let RecipeIngredients: _RecipeIngredient
        
        struct _RecipeIngredient: Decodable, Hashable {
            static func == (lhs: Recipe._IngredientAPI._RecipeIngredient, rhs: Recipe._IngredientAPI._RecipeIngredient) -> Bool {
                lhs.RecipeId == rhs.RecipeId && lhs.IngredientId == rhs.IngredientId
            }
            
            let quantity: Int
            let unit: String
            let RecipeId: UUID
            let IngredientId: UUID
        }
    }
}
