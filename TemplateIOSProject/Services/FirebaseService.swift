//
//  FirebaseService.swift
//  QuickLifts
//
//  Created by Tremaine Grant on 6/27/23.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage
import AuthenticationServices

enum FirebaseError: Error {
    case invalidCredentials
    case emailAlreadyInUse
    case unknownError
}

class FirebaseService: NSObject  {
    static let sharedInstance = FirebaseService()
    private var db: Firestore!
    var currentAuthorizationController: ASAuthorizationController?

    private override init() {
        FirebaseApp.configure()
        db = Firestore.firestore()
    }
    
    var isAuthenticated: Bool {
        guard (Auth.auth().currentUser?.uid) != nil else {
            return false
        }
        
        return true
    }
    
    func signInAnonymously(completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signInAnonymously(completion: completion)
    }
    
    func signInWithEmailAndPassword(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let authResult = authResult else {
                completion(.failure(FirebaseError.unknownError))
                return
            }
            
            let uid = authResult.user.uid
            
            self.db.collection("users").document(uid).getDocument { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = snapshot?.data(),
                      let user = User(id: snapshot?.documentID ?? "", dictionary: data) else {
                          completion(.failure(FirebaseError.unknownError))
                          return
                }
                
                completion(.success(user))
            }
        }
    }
    
    func signUpWithEmailAndPassword(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                self.createUserObject()
                completion(.success(authResult))
            } else {
                // This case should never occur, but handle it anyway
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])))
            }
        }
    }
    
    func deleteAccount(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(FirebaseError.unknownError))
            return
        }
        
        // Delete user's authentication
        user.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
//    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
//        guard let data = image.jpegData(compressionQuality: 0.6),
//              let userId = Auth.auth().currentUser?.uid else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid data or user id"])))
//            return
//        }
//
//        let storageRef = Storage.storage().reference().child("profile_images").child("\(userId).jpg")
//        storageRef.putData(data, metadata: nil) { (metadata, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            storageRef.downloadURL { (url, error) in
//                if let error = error {
//                    completion(.failure(error))
//                } else if let url = url {
//                    completion(.success(url.absoluteString))
//                }
//            }
//        }
//    }
    
    func createUserObject() {
        // Create a user object when a person first opens the app.
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        guard let email = Auth.auth().currentUser?.email else {
            return
        }
        
        let userRef = db.collection("users").document(userId)
        
        // Check if user document already exists
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting user document: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, !document.exists else {
                print("User document already exists")
                return
            }
            
            // Create new user document
            userRef.setData([
                "email": email,
                "createdAt": Date().timeIntervalSince1970,
                "updatedAt": Date().timeIntervalSince1970,
            ]) { (error) in
                if let error = error {
                    print("Error creating user document: \(error.localizedDescription)")
                } else {
                    print("User document created successfully")
                }
            }
        }
    }

    func changePassword(oldPassword: String, newPassword: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser, let email = currentUser.email else {
            completion(.failure(FirebaseError.unknownError))
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
        
        currentUser.reauthenticate(with: credential) { (_, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            currentUser.updatePassword(to: newPassword) { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                completion(.success(true))
            }
        }
    }

   func signOut() throws {
       try Auth.auth().signOut()
   }
    
}
