//
//  TeamsterUser.swift
//  Teamster
//
//  Created by Anthony Magner on 1/24/18.
//  Copyright © 2018 Anthony Magner. All rights reserved.
//

import Firebase

class TeamsterUser : NSObject
{
    var userID = ""
    var fullname = ""
    var profilePictureURL: URL?
    
    init(snapshot: DataSnapshot) {
        self.userID = snapshot.key
        guard let value = snapshot.value as? [String: Any] else { return }
        guard let fullname = value["full_name"] as? String else { return }
        self.fullname = fullname
        guard let profile_picture = value["profile_picture"] as? String,
            let profilePictureURL = URL(string: profile_picture) else { return }
        self.profilePictureURL = profilePictureURL
    }
    
    init(dictionary: [String: String]) {
        guard let uid = dictionary["uid"] else { return }
        self.userID = uid
        guard let fullname = dictionary["full_name"] else { return }
        self.fullname = fullname
        guard let profile_picture = dictionary["profile_picture"],
            let profilePictureURL = URL(string: profile_picture) else { return }
        self.profilePictureURL = profilePictureURL
    }
    
    private init(user: User) {
        self.userID = user.uid
        self.fullname = user.displayName ?? ""
        self.profilePictureURL = user.photoURL
    }
    
    static func currentUser() -> TeamsterUser {
        return TeamsterUser(user: Auth.auth().currentUser!)
    }
    
    func author() -> [String: String] {
        return ["uid": userID, "full_name": fullname, "profile_picture": profilePictureURL?.absoluteString ?? ""]
    }
}
