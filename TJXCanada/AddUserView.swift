//
//  AddUserView.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-22.
//

import SwiftUI

struct AddUserView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var users: [User]

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = "" // ✅ Email ajouté
    @State private var role: String = "employe"

    let roles = ["employe", "manager", "admin"] //type de role
    let firestore = FirestoreService()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nouvel utilisateur")) {
                    TextField("Nom d'utilisateur", text: $username)
                    SecureField("Mot de passe", text: $password)
                    TextField("Adresse e-mail", text: $email) // ✅ Champ email ajouté
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    Picker("Rôle", selection: $role) {
                        ForEach(roles, id: \.self) { role in
                            Text(role.capitalized)
                        }
                    }
                }

                Section {
                    Button("Ajouter l'utilisateur") {
                        addUser()
                    }
                }
            }
            .navigationTitle("Ajouter un utilisateur")
            .navigationBarItems(trailing: Button("Annuler") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    // 🔁 Fonction pour ajouter l'utilisateur
    func addUser() {
        var balances: [LeaveBalance] = []

        if role == "employe" {
            balances = [
                LeaveBalance(type: "VACATION", accrued: 40, approved: 0, pending: 0),
                LeaveBalance(type: "SICK", accrued: 24, approved: 0, pending: 0),
                LeaveBalance(type: "PERSONNEL", accrued: 25, approved: 0, pending: 0)
            ]
        }

        let newUser = User(
            id: UUID().uuidString,
            username: username,
            password: password,
            role: role,             // ✅ d'abord le rôle
            email: email,           // ✅ ensuite l’email
            leaveBalances: balances
        )

        users.append(newUser)

        firestore.addUser(newUser) { error in
            if let error = error {
                print("❌ Erreur lors de l’ajout Firestore : \(error.localizedDescription)")
            } else {
                print("✅ Utilisateur ajouté dans Firestore")
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
