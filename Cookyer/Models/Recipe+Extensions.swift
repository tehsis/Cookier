//
//  Recipe+Extensions.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/4/21.
//

import CoreData

extension Recipe {
    convenience init(context: NSManagedObjectContext, name: String, procedure: String) {
        self.init(context: context)
        self.name = name
        self.procedure = procedure
    }
    
    var nameString: String {
        name ?? ""
    }
    
    var procedureString: String {
        procedure ?? ""
    }
}
