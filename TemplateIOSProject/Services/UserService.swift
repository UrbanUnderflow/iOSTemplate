//
//  UserService.swift
//  QuickLifts
//
//  Created by Tremaine Grant on 6/27/23.
//

import Firebase
import FirebaseFirestore

enum UserServiceError: Error {
    case noValidRound
}

class UserService: ObservableObject {
    static let sharedInstance = UserService()
    private var db: Firestore!
    
    @Published var user: User? = nil
    
    private init() {
        db = Firestore.firestore()
    }
    
    func getUser(completion: @escaping (User?, Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil, nil)
            return
        }
        
        let userRef = db.collection("users").document(userId)
        
        // Add snapshot listener for user document
        userRef.getDocument { (document, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let document = document, document.exists else {
                completion(nil, nil)
                return
            }
            
            // Parse user data
            let userData = document.data() ?? [:]
            let user = User(id: document.documentID, dictionary: userData)
            
            self.user = user
            completion(user, nil)
        }
    }
    
    func deleteAccount(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        // Re-authenticate the user using their username and password
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        Auth.auth().currentUser?.reauthenticate(with: credential) { [weak self] _, error in
            guard let self = self else { return }
            
            if let error = error {
                // Handle re-authentication error
                print("Error re-authenticating user: \(error)")
                return
            }
            
            guard let userId = Auth.auth().currentUser?.uid else {
                // Unable to retrieve user ID
                return
            }
            
            // Delete user's data
            let userRef = self.db.collection("users").document(userId)
            userRef.delete { error in
                if let error = error {
                    // Handle data deletion error
                    print("Error deleting user's data: \(error)")
                    return
                }
                
                // Delete user's authentication
                FirebaseService.sharedInstance.deleteAccount { result in
                    switch result {
                    case .success(_):
                        self.user = nil
                        completion(.success(true))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func updateUser(user: User,
                    id: String? = nil,
                    email: String? = nil,
                    name: String? = nil,
                    goal: WorkoutGoal? = nil,
                    createdAt: Date? = nil,
                    updatedAt: Date? = nil) {
        // Create a user object when a person first opens the app.
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
      
        var updatedUser = user
                
        updatedUser.id = id ?? user.id
        updatedUser.email = email ?? user.email
        updatedUser.name = name ?? user.name
        updatedUser.createdAt = createdAt ?? user.createdAt
        updatedUser.updatedAt = updatedAt ?? Date()
        
        UserService.sharedInstance.user = updatedUser

        let userRef = db.collection("users").document(userId)
        userRef.setData(updatedUser.toDictionary()) { (error) in
            if let error = error {
                print("Error updating user document: \(error.localizedDescription)")
            } else {
                print("User document updated successfully")
            }
        }
    }
}
