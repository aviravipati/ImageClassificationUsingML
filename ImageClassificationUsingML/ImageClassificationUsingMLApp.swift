//
//  ImageClassificationUsingMLApp.swift
//  ImageClassificationUsingML
//
//  Created by Avinash Ravipati on 12/3/23.
//

import SwiftUI

@main
struct ImageClassificationUsingMLApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
