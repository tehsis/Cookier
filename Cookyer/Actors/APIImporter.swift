//
//  ApiImporter.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/13/21.
//

import Foundation
import CoreData
import Combine

class DataImporter {
    let importContext: NSManagedObjectContext
    let decoder: JSONDecoder
    var cancellable: AnyCancellable!
    
    init(persistentContainer: NSPersistentContainer) {
        importContext = persistentContainer.newBackgroundContext()
        importContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        decoder = JSONDecoder()

        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = importContext
    }
    
    func runImport() {
        let url = URL(string: "https://cookier.alidion.studio/recipes")!
        
       cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Something went wrong: \(error)")
                }
                
            }, receiveValue: { [weak self] data in
                guard let self = self else { return }
                
                self.importContext.perform {
                    do {
                        _ = try self.decoder.decode([Recipe].self, from: data)
                        
                        try self.importContext.save()
                    } catch {
                        print("Failed to decode json: \(error)")
                    }
                }
            
            })
        
    }
}
