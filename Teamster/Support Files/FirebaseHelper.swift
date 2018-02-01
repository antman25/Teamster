//
//  FirebaseHelper.swift
//  Teamster
//
//  Created by Anthony Magner on 1/28/18.
//  Copyright © 2018 Anthony Magner. All rights reserved.
//

import Firebase


class FirebaseHelper {
    //static let shared = FirebaseAPI()
    
    private init() {}
    
    static func loginUser(user: User?)
    {
        if let user = user {
            print ("login UID: \(user.uid)")
            let meta = ["email": user.email,
                        "name": user.displayName
                        ]
            
            let online = ["time" : Date().timeIntervalSince1970,
                          "uid" : user.uid ] as [String : Any]
            
            let updated = [ "meta" : Date().timeIntervalSince1970]
            
            //let login_data = ["meta" : meta,
            //                  "online" : true,
            //                  updated
            //                  ]
            Constants.refs.databaseUsers.child(user.uid).child("meta").updateChildValues(meta)
            Constants.refs.databaseUsers.child(user.uid).child("online").setValue(true)
            Constants.refs.databaseOnline.child(user.uid).updateChildValues(online)
            
            Constants.refs.databaseUsers.child(user.uid).child("updated").updateChildValues(updated)
            //Constants.refs.databaseUsers.child(user.uid).child("online").set
            
            FirebaseHelper.sendMessage(uidFrom: user.uid, uidTo: "FJYcE0Gw7ibgfiuHxXaQUhXzguD3",message: "Test Message")
            //FirebaseHelper.sendMessage(uidFrom: "FJYcE0Gw7ibgfiuHxXaQUhXzguD3" , uidTo: "LCMrfOEU1pQsHBjdsz9dek8y4ni1" ,message: "Test Message Response")
            let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                print ("-----------Sending Message 2 -----------------")
                //FirebaseHelper.sendMessage(uidFrom: "FJYcE0Gw7ibgfiuHxXaQUhXzguD3" , uidTo: "LCMrfOEU1pQsHBjdsz9dek8y4ni1" ,message: "Test Message Response")
                
            }

            
        }
        //Constants.refs.databaseRoot.child(
    }
    
    static func logoutUser(user: User?)
    {
        if let user = user {
            print ("Logout UID: \(user.uid)")
            //Constants.refs.databaseOnline.child(user.uid).child("online").setValue(false)
            Constants.refs.databaseOnline.child(user.uid).setValue(false)
            Constants.refs.databaseUsers.child(user.uid).child("online").setValue(false)
            //let online = ["online" : false]
        }
    }
    
    static func sendMessage(uidFrom: String, uidTo: String, message: String)
    {
        print("Sending Message: \(uidFrom) -> \(uidTo) : \(message)")
        
        //Constants.refs.databaseUsers.child(uidFrom).child("threads").queryEqual(toValue: Any?)
        
        //let threadKey = Constants.refs.databaseThreads.childByAutoId().key
        //Constants.refs.databaseUsers.child(uidFrom).child("threads").observesingleevent
        
        var existingThreads: [String] = []
        var existingUsers: [String : String] = [:]
        var foundExistingThread = false
        Constants.refs.databaseUsers.child(uidFrom).child("threads").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let value = snapshot.value as? NSDictionary
            {
                //print ("Main Value: \(value)")
                for (key, _) in value {
                    print("Found Thread: \(key as! String)")
                    existingThreads.append(key as! String)
                    let currentThread = key as! String
                    Constants.refs.databaseThreads.child(key as! String).child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        if let value = snapshot.value as? NSDictionary
                        {
                            print ("User Lookup Value: \(value)")
                            for (key, role) in value {
                                if let key = key as? String, let role = role as? String {
                                    print("Key: \(key) Role: \(role)")
                                    if uidTo == key {
                                        foundExistingThread = true
                                        print ("Existing thread FOUND for \(currentThread)")
                                        
                                        let messages = Constants.refs.databaseThreads.child(currentThread).child("messages").childByAutoId()
                                        
                                        let timestamp = Date().timeIntervalSince1970
                                        let lastMessage = [ "date" : timestamp,
                                                            "payload" : message,
                                                            "type" : "0",
                                                            "user-firebase-id" : uidFrom,
                                                            "username" : ""
                                            
                                            
                                            ] as [String : Any]
                                        let threadID = Constants.refs.databaseThreads.child(currentThread)
                                        threadID.child("lastMessage").updateChildValues(lastMessage)
                                        let message = [ "date" : timestamp,
                                                        "payload" : message,
                                                        "type" : "0",
                                                        "user-firebase-id" : uidFrom,
                                                        ] as [String : Any]
                                        
                                        messages.updateChildValues(message)
                                        
                                    }
                                }
                            
                            }
                        }
                    })
                    
                    
                }
                print ("Existing Threads In DB: \(existingThreads)")
            }
            else
            {
                print ("NO THREADS")
                
                let threadID = createThread(uidFrom: uidFrom, uidTo: uidTo, displayName: "", message: message)
                print ("Created Thread: \(threadID)")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
        //print ("Existing Threads EXIT: \(existingThreads)")
        print ("MARK")
    }
    
    static func addMessage(uidFrom: String, uidTo: String, displayName: String, message: String)
    {
        
    }
    
    static func createThread(uidFrom: String, uidTo: String, displayName: String, message: String) -> String
    {
        let threadID = Constants.refs.databaseThreads.childByAutoId()
        //threadID.child("invitedBy").setValue(uidFrom)
        
        let timestamp = Date().timeIntervalSince1970
        let details = [ "creation_date" : timestamp,
                        "creator_uid" : uidFrom
            ] as [String : Any]
        
        let lastMessage = [ "date" : timestamp,
                            "payload" : message,
                            "type" : "0",
                            "user-firebase-id" : uidFrom,
                            "username" : displayName
            ] as [String : Any]
        let users = [ uidFrom : "owner",
                      uidTo : "member"]
        
        threadID.child("users").updateChildValues(users)
        threadID.child("details").updateChildValues(details)
        threadID.child("lastMessage").updateChildValues(lastMessage)
        
        
        let messages = threadID.child("messages").childByAutoId()
        
        let message = [ "date" : timestamp,
                        "payload" : message,
                        "type" : "0",
                        "user-firebase-id" : uidFrom,
            ] as [String : Any]
        
        messages.updateChildValues(message)
        
        let threadFrom = Constants.refs.databaseUsers.child(uidFrom).child("threads").child(threadID.key)
        threadFrom.updateChildValues(["invitedBy" : uidFrom])
        let threadTo = Constants.refs.databaseUsers.child(uidTo).child("threads").child(threadID.key)
        threadTo.updateChildValues(["invitedBy" : uidFrom])
        
        Constants.refs.databaseUsers.child(uidFrom).child("updated").updateChildValues(["threads" : timestamp])
        Constants.refs.databaseUsers.child(uidTo).child("updated").updateChildValues(["threads" : timestamp])
        
        return threadID.key
    }
    
    static func addToThread(threadID : String, uidFrom: String){
        
    }
    
}
