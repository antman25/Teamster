//
//  UserTableViewController.swift
//  Teamster
//
//  Created by Anthony Magner on 1/28/18.
//  Copyright © 2018 Anthony Magner. All rights reserved.
//

import UIKit
import Firebase

class UserTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let query = Constants.refs.databaseUsers.child(Auth().currentUser?.uid).child("messages").queryLimited(toLast: 10)
        
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            
            /*if  let data        = snapshot.value as? [String: String],
             let id          = data["sender_id"],
             let name        = data["name"],
             let text        = data["text"],
             !text.isEmpty
             {
             if let message = JSQMessage(senderId: id, displayName: name, text: text)
             {
             self?.messages.append(message)
             
             self?.finishReceivingMessage()
             }
             }*/
            //print ("Snapshot: \(snapshot)")
            if  let data        = snapshot.value as? NSDictionary {
                if let date = data["date"],
                    let payload = data["payload"],
                    let type = data["type"],
                    let userId = data["user-firebase-id"]
                {
                    let dateConverted = NSDate(timeIntervalSince1970: Double(truncating: date as! NSNumber))
                    print("\(dateConverted) -- \(userId) = \(payload)")
                    let sender = Sender(id: userId as! String, displayName: "FromUser")
                    self?.messageList.append(ChatPrivateMessage(text: payload as! String, sender: sender, messageId: snapshot.key, date: dateConverted as Date))
                    
                    self?.messagesCollectionView.reloadData()
                    self?.messagesCollectionView.scrollToBottom()
                }
                
                print("Message Count: \(self?.messageList.count)")
                //print("Payload: \(data["payload"])")
            }
            else
            {
                print ("No data in observe")
            }
            // print("MessageID: \(snapshot.key)")
            /*if  let data        = snapshot.value as? NSDictionary {
             for (key, meta) in data {
             print ("Key: \(key)")
             print ("Meta: \(meta)")
             if let key = key as? String, let messageMeta = meta as? NSDictionary {
             
             }
             }
             }*/
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UserTableViewCell
        
        // Configure the cell...

        return cell!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
