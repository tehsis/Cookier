//
//  DecodableNSMOC.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/13/21.
//

import Foundation

enum DecoderConfigurationError: Error {
    case missingManageObjectContext
}


extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
