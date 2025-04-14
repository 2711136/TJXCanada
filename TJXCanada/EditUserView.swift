//
//  EditUserView.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-23.
//
import SwiftUI

struct EditUserView: View {
    @Binding var user: User
    @Environment(\.presentationMode) var presentationMode

    @State private var updatedUsername: String
    @State private var updatedPassword: String
    @State private var updatedRole: String

    let roles = ["employe", "manager", "admin"]

    init(user: Binding<User>) {
        _user = user
        _updatedUsername = State(initialValue: user.wrappedValue.username)
        _updatedPassword = State(initialValue: user.wrappedValue.password)
        _updatedRole = State(initialValue: user.wrappedValue.role)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Modifier l'utilisateur")) {
                    TextField("Nom d'utilisateur", text: $updatedUsername)
                    SecureField("Mot de passe", text: $updatedPassword)

                    Picker("Rôle", selection: $updatedRole) {
                        ForEach(roles, id: \.self) { role in
                            Text(role.capitalized)
                        }
                    }
                }

                Button("✅ Enregistrer") {
                    user.username = updatedUsername
                    user.password = updatedPassword
                    user.role = updatedRole

                    // 💾 Optionnel : mettre à jour Firestore ici si nécessaire
                    FirestoreService().addUser(user) { error in
                        if let error = error {
                            print("❌ Erreur Firestore : \(error.localizedDescription)")
                        } else {
                            print("✅ Utilisateur mis à jour avec succès")
                        }
                    }

                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Modifier")
            .navigationBarItems(trailing: Button("Annuler") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

