//
//  TJXCanadaApp.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-22.
//

import SwiftUI
import Firebase

@main
struct TJXCanadaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var firestoreService = FirestoreService()

    var body: some Scene {
        WindowGroup {
            WelcomeView()

                .environmentObject(firestoreService)
                .onAppear {
                    // ✅ Sûr que Firebase est initialisé ici
                    firestoreService.addDefaultUsers()
                }
        }
    }
}
