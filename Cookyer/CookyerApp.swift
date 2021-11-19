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
    let dataImporter = DataImporter(persistentContainer: PersistenceController.shared.container)


    var body: some Scene {
        WindowGroup {
            RecipeList()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in

                    dataImporter.runImport()
                }
        }
    }
}
