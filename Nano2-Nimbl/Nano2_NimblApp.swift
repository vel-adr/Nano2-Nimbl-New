//
//  Nano2_NimblApp.swift
//  Nano2-Nimbl
//
//  Created by Anselmus Pavel Adriska on 04/01/23.
//

import SwiftUI

@main
struct Nano2_NimblApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
