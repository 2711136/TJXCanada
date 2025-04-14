//
//  EmailService.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-24.
//
import Foundation

struct EmailData: Codable {
    let service_id: String
    let template_id: String
    let user_id: String
    let template_params: [String: String]
}

class EmailService {
    static func sendEmail(to name: String, email: String, status: String, startDate: String, endDate: String) {
        let url = URL(string: "https://api.emailjs.com/api/v1.0/email/send")!

        let emailData = EmailData(
            service_id: "service_zn7tt4b", // ✅ Ton service Gmail via OAuth
            template_id: "template_8yrug69", // ✅ Ton template actif
            user_id: "ivNHCqJ_m_hsprUL4", // ✅ Ta clé publique EmailJS
            template_params: [
                "user_name": name,
                "user_email": email,
                "status": status,
                "start_date": startDate,
                "end_date": endDate,
                "message": "Votre demande a été \(status.lowercased())",
                "name": name
            ]
        )

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(emailData)
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("✅ Email envoyé ! Code : \(httpResponse.statusCode)")
                    } else if httpResponse.statusCode == 400 {
                        print("❗️Vérifie bien les champs `template_params` et leur orthographe.")
                    } else if httpResponse.statusCode == 403 {
                        print("❌ Mauvais service_id, template_id ou user_id.")
                    } else {
                        print("❗️ Code inconnu : \(httpResponse.statusCode)")
                    }
                }

                if let error = error {
                    print("❌ Erreur réseau : \(error.localizedDescription)")
                }
            }.resume()

        } catch {
            print("❌ Erreur d'encodage JSON : \(error)")
        }
    }
}
