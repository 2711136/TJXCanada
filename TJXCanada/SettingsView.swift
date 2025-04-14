//
//  SettingsView.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Compte")) {
                    HStack {
                        Label("Nom d’utilisateur", systemImage: "person.fill")
                        Spacer()
                        Text("Bamba") // Tu peux remplacer dynamiquement
                    }
                    HStack {
                        Label("Rôle", systemImage: "briefcase.fill")
                        Spacer()
                        Text("Employé")
                    }
                }

                Section {
                    Button(action: {
                        // Action déconnexion ici
                    }) {
                        Label("Déconnexion", systemImage: "arrow.backward.square.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Paramètres")
        }
    }
}
