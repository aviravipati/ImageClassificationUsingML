//
//  ContentView.swift
//  ImageClassificationUsingML
//
//  Created by Avinash Ravipati on 12/3/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        ImageSelectionView()
        
    }

}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
