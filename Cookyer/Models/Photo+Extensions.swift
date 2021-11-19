//
//  Photo+Extensions.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/4/21.
//

import CoreData

class Photo: NSManagedObject, Decodable {
    
    
    var photoUrlCDN: URL? {
        guard let originalUrl = url?.absoluteString else {
            return nil
        }
        
        var cdnURL = URL(string: "https://d2lgi4cdz4su7s.cloudfront.net")!
        
        cdnURL.appendPathComponent(originalUrl)
        
        return cdnURL
    }
    
    enum codingKeys: CodingKey {
        case id, url, Recipe
    }
    
    convenience init(context: NSManagedObjectContext, uri: URL) {
        self.init(context: context)
        self.url = uri
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManageObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: codingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.url = try container.decode(URL.self, forKey: .url)
    }
}
