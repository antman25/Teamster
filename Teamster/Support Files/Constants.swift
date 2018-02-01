//
//  Constants.swift
//  Teamster
//
//  Created by Anthony Magner on 1/28/18.
//  Copyright © 2018 Anthony Magner. All rights reserved.
//

import Firebase

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let sandbox = databaseRoot.child("sandbox")
        static let databaseOnline = sandbox.child("online")
        static let databaseSearch = sandbox.child("searchindex")
        static let databaseThreads = sandbox.child("threads")
        static let databaseUsers = sandbox.child("users")
        
    }
}
