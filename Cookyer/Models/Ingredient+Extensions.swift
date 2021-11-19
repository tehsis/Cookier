//
//  Ingredientes+Extensions.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/4/21.
//

import CoreData

class Ingredient: NSManagedObject, Decodable {
    
    // MARK: CoreData helpers
    var nameString: String {
        name ?? ""
    }
    
    var recipeIngredients: Recipe_Ingredients?
    
    enum codingKeys: CodingKey {
        case id, name, RecipeIngredients
    }
    
    convenience init(context: NSManagedObjectContext, id: UUID = UUID(), name: String) {
        self.init(context: context)
        self.id = id
        self.name = name
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManageObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: codingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
}

