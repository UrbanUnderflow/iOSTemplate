//
//  User.swift
//  QuickLifts
//
//  Created by Tremaine Grant on 6/27/23.
//

import Foundation

enum WorkoutGoal: String {
    case loseWeight
    case gainWeight
    case toneUp
}

struct User {
    var id: String
    var email: String
    var name: String
    var goal: WorkoutGoal?
    var createdAt: Date
    var updatedAt: Date

    init(id: String,
         email: String,
         name: String,
         goal: WorkoutGoal?,
         createdAt: Date,
         updatedAt: Date) {
        self.id = id
        self.name = name
        self.email = email
        self.goal = goal
        self.createdAt = createdAt
        self.updatedAt = updatedAt
       
    }

    init?(id: String, dictionary: [String: Any]) {
        self.id = id
        self.email = dictionary["email"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        
        
        self.goal = WorkoutGoal(rawValue: dictionary["goal"] as? String ?? "")

        let createdAtTimestamp = dictionary["createdAt"] as? Double ?? 0
        let updatedAtTimestamp = dictionary["updatedAt"] as? Double ?? 0

        self.createdAt = Date(timeIntervalSince1970: createdAtTimestamp)
        self.updatedAt = Date(timeIntervalSince1970: updatedAtTimestamp)

    }
    
    func updateUserObject() -> User {
        var newUser = self
        newUser.updatedAt = Date()
        UserService.sharedInstance.user = self

        return newUser
    }

    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "email": email,
            "name": name,
            "goal": goal?.rawValue,
            "createdAt": createdAt.timeIntervalSince1970,
            "updatedAt": updatedAt.timeIntervalSince1970
        ]
    }
}

