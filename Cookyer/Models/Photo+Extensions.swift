//
//  Photo+Extensions.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/4/21.
//

import CoreData

extension Photo {
    convenience init(context: NSManagedObjectContext, uri: URL) {
        self.init(context: context)
        self.url = uri
    }
}
