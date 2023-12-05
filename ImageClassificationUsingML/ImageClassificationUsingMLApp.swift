//
//  ImageClassificationUsingMLApp.swift
//  ImageClassificationUsingML
//
//  Created by Avinash Ravipati on 12/3/23.
//

import SwiftUI
import Vision

@main
struct ImageClassificationUsingMLApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ImageSelectionView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
