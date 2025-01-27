//
//  LogiSyncManagerApp.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/09.
//

import SwiftUI
import SwiftData

@main
struct LogiSyncManagerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(EnvironViewModel())
        }
        .modelContainer(sharedModelContainer)
    }
}
