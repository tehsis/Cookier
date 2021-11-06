//
//  CookyerApp.swift
//  Cookyer
//
//  Created by Pablo Terradillos on 11/3/21.
//

import SwiftUI

@main
struct CookyerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
