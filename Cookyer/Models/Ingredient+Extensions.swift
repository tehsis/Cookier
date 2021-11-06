//
//  Ingredientes+Extensions.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/4/21.
//

import CoreData

extension Ingredient {
    convenience init(context: NSManagedObjectContext, name: String) {
        self.init(context: context)
        self.name = name
    }
}
