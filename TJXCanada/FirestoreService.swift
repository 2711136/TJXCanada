//
//  FirestoreService.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-22.
//

import Foundation
import FirebaseFirestore

class FirestoreService: ObservableObject {
    private var db: Firestore {
        return Firestore.firestore()
    }

    // 🔹 Ajouter un utilisateur
    func addUser(_ user: User, completion: @escaping (Error?) -> Void) {
        let docRef = db.collection("users").document()
        let balancesData = user.leaveBalances.map { balance in
            return [
                "type": balance.type,
                "accrued": balance.accrued,
                "approved": balance.approved,
                "pending": balance.pending
            ]
        }

        let data: [String: Any] = [
            "id": docRef.documentID,
            "username": user.username,
            "password": user.password,
            "email": user.email,
            "role": user.role,
            "leaveBalances": balancesData
        ]

        docRef.setData(data, completion: completion)
    }

    // 🔐 Authentifier un utilisateur
    func authenticateUser(username: String, password: String, completion: @escaping (User?) -> Void) {
        db.collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Erreur Firestore : \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let document = snapshot?.documents.first else {
                    print("Aucun utilisateur trouvé.")
                    completion(nil)
                    return
                }

                let data = document.data()
                let storedPassword = data["password"] as? String ?? ""

                if storedPassword == password {
                    let balancesArray = data["leaveBalances"] as? [[String: Any]] ?? []
                    let balances = balancesArray.map { entry in
                        LeaveBalance(
                            type: entry["type"] as? String ?? "",
                            accrued: entry["accrued"] as? Double ?? 0,
                            approved: entry["approved"] as? Double ?? 0,
                            pending: entry["pending"] as? Double ?? 0
                        )
                    }

                    let user = User(
                        id: document.documentID,
                        username: data["username"] as? String ?? "",
                        password: storedPassword,
                        role: data["role"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        leaveBalances: balances
                    )

                    completion(user)
                } else {
                    print("Mot de passe incorrect.")
                    completion(nil)
                }
            }
    }

    // 🔹 Supprimer un utilisateur
    func deleteUser(_ user: User) {
        db.collection("users").document(user.id).delete { error in
            if let error = error {
                print("❌ Erreur suppression utilisateur : \(error.localizedDescription)")
            } else {
                print("✅ Utilisateur supprimé avec succès")
            }
        }
    }

    // 🔹 Récupérer tous les utilisateurs
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("❌ fetchUsers error: \(error.localizedDescription)")
                completion([])
                return
            }

            let users = snapshot?.documents.compactMap { doc -> User? in
                let data = doc.data()

                let balancesArray = data["leaveBalances"] as? [[String: Any]] ?? []
                let balances = balancesArray.map { entry in
                    LeaveBalance(
                        type: entry["type"] as? String ?? "",
                        accrued: entry["accrued"] as? Double ?? 0,
                        approved: entry["approved"] as? Double ?? 0,
                        pending: entry["pending"] as? Double ?? 0
                    )
                }

                return User(
                    id: doc.documentID,
                    username: data["username"] as? String ?? "",
                    password: data["password"] as? String ?? "",
                    role: data["role"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    leaveBalances: balances
                )
            } ?? []

            completion(users)
        }
    }

    // 🔹 Ajouter une demande de congé
    func addLeaveRequest(_ request: LeaveRequest, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            "id": request.id,
            "type": request.type,
            "startDate": Timestamp(date: request.startDate),
            "endDate": Timestamp(date: request.endDate),
            "status": request.status,
            "employeeName": request.employeeName,
            "employeeId": request.employeeId
        ]
        db.collection("leaveRequests").document(request.id).setData(data, completion: completion)
    }

    // 🔹 Récupérer toutes les demandes de congé
    func fetchLeaveRequests(completion: @escaping ([LeaveRequest]) -> Void) {
        db.collection("leaveRequests").getDocuments { snapshot, error in
            if let error = error {
                print("❌ fetchLeaveRequests error: \(error.localizedDescription)")
                completion([])
                return
            }

            let requests = snapshot?.documents.compactMap { doc -> LeaveRequest? in
                let data = doc.data()
                return LeaveRequest(
                    id: data["id"] as? String ?? "",
                    type: data["type"] as? String ?? "",
                    startDate: (data["startDate"] as? Timestamp)?.dateValue() ?? Date(),
                    endDate: (data["endDate"] as? Timestamp)?.dateValue() ?? Date(),
                    status: data["status"] as? String ?? "",
                    employeeName: data["employeeName"] as? String ?? "",
                    employeeId: data["employeeId"] as? String ?? ""
                )
            } ?? []

            completion(requests)
        }
    }

    // 🔹 Récupérer les demandes pour un utilisateur spécifique
    func fetchLeaveRequests(for userId: String, completion: @escaping ([LeaveRequest]) -> Void) {
        db.collection("leaveRequests")
            .whereField("employeeId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ fetchLeaveRequests(for:) error: \(error.localizedDescription)")
                    completion([])
                    return
                }

                let requests = snapshot?.documents.compactMap { doc -> LeaveRequest? in
                    let data = doc.data()
                    return LeaveRequest(
                        id: data["id"] as? String ?? "",
                        type: data["type"] as? String ?? "",
                        startDate: (data["startDate"] as? Timestamp)?.dateValue() ?? Date(),
                        endDate: (data["endDate"] as? Timestamp)?.dateValue() ?? Date(),
                        status: data["status"] as? String ?? "",
                        employeeName: data["employeeName"] as? String ?? "",
                        employeeId: data["employeeId"] as? String ?? ""
                    )
                } ?? []

                completion(requests)
            }
    }

    // 🔄 Mettre à jour les soldes de congé d’un utilisateur
    func updateBalances(for userId: String, newBalances: [LeaveBalance], completion: @escaping (Error?) -> Void) {
        let balancesData = newBalances.map { balance in
            return [
                "type": balance.type,
                "accrued": balance.accrued,
                "approved": balance.approved,
                "pending": balance.pending
            ]
        }

        db.collection("users").document(userId).updateData([
            "leaveBalances": balancesData
        ], completion: completion)
    }

    // 🔹 Récupérer les absences signalées d’un utilisateur
    func fetchAbsences(for userId: String, completion: @escaping ([Absence]) -> Void) {
        db.collection("absences")
            .whereField("employeeId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ fetchAbsences error: \(error.localizedDescription)")
                    completion([])
                    return
                }

                let absences = snapshot?.documents.compactMap { doc -> Absence? in
                    let data = doc.data()
                    return Absence(
                        id: data["id"] as? String ?? "",
                        reason: data["reason"] as? String ?? "",
                        date: (data["date"] as? Timestamp)?.dateValue() ?? Date(),
                        employeeId: data["employeeId"] as? String ?? ""
                    )
                } ?? []

                completion(absences)
            }
    }

    // 🔹 Ajouter les utilisateurs par défaut
    func addDefaultUsers() {
        let defaultBalances: [LeaveBalance] = [
            LeaveBalance(type: "Vacances", accrued: 40, approved: 0, pending: 0),
            LeaveBalance(type: "Maladie", accrued: 24, approved: 0, pending: 0),
            LeaveBalance(type: "Personnel", accrued: 16, approved: 0, pending: 0)
        ]

        let defaultUsers = [
            User(id: "", username: "admin", password: "admin123", role: "admin", email: "admin@tjx.ca", leaveBalances: []),
            User(id: "", username: "manager", password: "manager123", role: "manager", email: "manager@tjx.ca", leaveBalances: []),
            User(id: "", username: "employe", password: "employe123", role: "employe", email: "employe@tjx.ca", leaveBalances: defaultBalances)
        ]

        for user in defaultUsers {
            db.collection("users")
                .whereField("username", isEqualTo: user.username)
                .getDocuments { snapshot, error in
                    if let snapshot = snapshot, snapshot.isEmpty {
                        self.addUser(user) { error in
                            if let error = error {
                                print("❌ Erreur ajout \(user.username) : \(error.localizedDescription)")
                            } else {
                                print("✅ Utilisateur ajouté : \(user.username)")
                            }
                        }
                    } else {
                        print("ℹ️ \(user.username) existe déjà")
                    }
                }
        }
    }
}
