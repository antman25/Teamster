//
//  ProfileViewController.swift
//  Teamster
//
//  Created by Anthony Magner on 1/23/18.
//  Copyright © 2018 Anthony Magner. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher
import FBSDKLoginKit
import CoreLocation
import FirebaseDatabase
import GeoFire


class ProfileViewController: UIViewController {

    @IBOutlet weak var testImage: UIImageView!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    
    var nearbyUsers: [String] = []
    let locationManager = CLLocationManager()
    var currentLocation=""
    var locValue:CLLocationCoordinate2D?
    
    @IBAction func geoFirePressed(_ sender: Any) {
        /*let geofireRef = Database.database().reference()
        let geoFire = GeoFire(firebaseRef: geofireRef)
        geoFire.setLocation(CLLocation(latitude: 37.7853889, longitude: -122.4056973), forKey: "firebase-hq") { (error) in
            if (error != nil) {
                print("An error occured")
            } else {
                print("Saved location successfully!")
            }
        }*/
        let ref = Database.database().reference()
        let geoFire = GeoFire(firebaseRef: ref.child("users_locations"))
        let myLocation = CLLocation(latitude: (locValue?.latitude)!, longitude: (locValue?.longitude)!)
            
        let userID = Auth.auth().currentUser!.uid
        geoFire.setLocation(myLocation, forKey: userID) { (error) in
            if (error != nil) {
                debugPrint("An error occured: \(String(describing: error))")
            } else {
                print("Saved location successfully!")
            }
        }
        
        /*let loc1 = CLLocation(latitude: 39.9673053017, longitude: -104.9960894511)
        geoFire.setLocation(loc1, forKey: "Westminster") { (error) in
            if (error != nil) {
                debugPrint("An error occured: \(String(describing: error))")
            } else {
                print("Saved location successfully!")
            }
        }
        
        let loc2 = CLLocation(latitude: 39.9044547927, longitude: -105.0868738308)
        geoFire.setLocation(loc2, forKey: "Broomfield") { (error) in
            if (error != nil) {
                debugPrint("An error occured: \(String(describing: error))")
            } else {
                print("Saved location successfully!")
            }
        }
        
        let loc3 = CLLocation(latitude: 39.7514837917, longitude: -105.0038595629)
        geoFire.setLocation(loc3, forKey: "Denver") { (error) in
            if (error != nil) {
                debugPrint("An error occured: \(String(describing: error))")
            } else {
                print("Saved location successfully!")
            }
        }*/
        
        findNearbyUsers()

    }
    
    func findNearbyUsers() {
        
        let myLocation = CLLocation(latitude: (locValue?.latitude)!, longitude: (locValue?.longitude)!)
        //if let myLocation = myLocation {
        let radiusInMeters = 30000.0
        let ref = Database.database().reference()
        let theGeoFire = GeoFire(firebaseRef: ref.child("users_locations"))
        let circleQuery = theGeoFire.query(at: myLocation, withRadius: radiusInMeters/1000)
        
        _ = circleQuery.observe(.keyEntered, with: { (key, location) in

            print ("Returned Key: \(key)")
            if !self.nearbyUsers.contains(key) && key != Auth.auth().currentUser!.uid {
                self.nearbyUsers.append(key)
                print ("Nearby User: \(self.nearbyUsers)")
            }
            
        })
        
        //Execute this code once GeoFire completes the query!
        circleQuery.observeReady({
            //let ref = Database.database().reference()
            for user in self.nearbyUsers {
                
                ref.child("users/\(user)").observe(.value, with: { snapshot in
                    let value = snapshot.value as? NSDictionary
                    print("Observe: \(value)")
                })
            }
            
        })
            
        //}
        
    }
    
    func getChatID(uid1: String, uid2: String)
    {
        
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
        }
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        appDel.window?.rootViewController = TeamsterSignInViewController()
    }
    
    @IBAction func buildUser(_ sender: Any) {
        generateUser()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfilePic()
        // Do any additional setup after loading the view.
        
        // Ask for Authorisation from the User.
       // self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            if ((UIDevice.current.systemVersion as NSString).floatValue >= 8)
            {
                locationManager.requestWhenInUseAuthorization()
            }
            
            locationManager.startUpdatingLocation()
        }
        else
        {
            #if debug
                println("Location services are not enabled");
            #endif
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getProfilePicURL() -> String {
        var facebookUserId: String = ""
        var photoUrl:String = ""
        if let user = Auth.auth().currentUser {
            for profile in user.providerData {
                if (profile.providerID == "facebook.com"){
                    facebookUserId = profile.uid
                    print ("UID: \(profile.uid)")
                    photoUrl = "https://graph.facebook.com/" + facebookUserId + "/picture?type=large"
                }
                else if profile.providerID == "google.com"{
                    photoUrl = (profile.photoURL?.absoluteString)!
                    photoUrl = photoUrl.replacingOccurrences(of: "/s96-c/", with: "/s300-c/")
                }
            }
            
            //let photoUrl = (user.photoURL?.absoluteString)! + "?type=large"
            print("BIG url: \(photoUrl)")
            return photoUrl
        }
        return ""
    }
    
    
    
    func loadProfilePic()
    {
        //print("URL: " + Auth.auth().currentUser?.displayName)
        testLabel.text = Auth.auth().currentUser?.displayName
        //let picurl=?.photoURL?.absoluteString
        //let photoUrl = (Auth.auth().currentUser?.photoURL?.absoluteString)! + "?type=large"
        var facebookUserId: String = ""
        var photoUrl:String = ""
        if let user = Auth.auth().currentUser {
            for profile in user.providerData {
                if (profile.providerID == "facebook.com"){
                    facebookUserId = profile.uid
                    print ("UID: \(profile.uid)")
                    photoUrl = "https://graph.facebook.com/" + facebookUserId + "/picture?type=large"
                }
                else if profile.providerID == "google.com"{
                    photoUrl = (profile.photoURL?.absoluteString)!
                    //photoUrl = photoUrl.replace("/s96-c/","/s300-c/");
                    photoUrl = photoUrl.replacingOccurrences(of: "/s96-c/", with: "/s300-c/")
                }
                
                //let url = URL(string: (user.photoURL?.absoluteString)! + "?type=large")!
                //let photoUrl:String = profile.photoURL!.absoluteString + "?type=large"//SMALL IMAGE
            //    testImage.kf.setImage(with: photoUrl)
            }
            
            //let photoUrl = (user.photoURL?.absoluteString)! + "?type=large"
            print("BIG url: \(photoUrl)")
            let url = URL(string: photoUrl)
            let processor = /*BlurImageProcessor(blurRadius: 0) >>*/ RoundCornerImageProcessor(cornerRadius: 150)
            testImage.kf.setImage(with: url, placeholder: nil, options: [.processor(processor)])
            //testImage.image = testImage.image?.circle
            //estImage.kf.setImage(with: url)
        }
        
    }
}

extension ProfileViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        locValue = manager.location!.coordinate
        locationLabel.text = "\(locValue?.latitude ?? 0.0) \(locValue?.longitude ?? 0.0)"
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: locValue!.latitude, longitude: locValue!.longitude)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        //geocodeButton.isHidden = false
        //activityIndicatorView.stopAnimating()
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            locationNameLabel.text = "Unable to Find Address for Location"
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                locationNameLabel.text = placemark.compactAddress
                //print(placemark)
                currentLocation = placemark.locality!
            } else {
                locationNameLabel.text = "No Matching Addresses Found"
            }
        }
    }
    
    func generateUser()
    {
        let user = Auth.auth().currentUser!
        Database.database().reference(withPath: "user/\(user.uid)")
            .updateChildValues(["profile_picture": getProfilePicURL(),
                                "full_name": user.displayName ?? "Anonymous",
                                "_search_index": ["full_name": user.displayName?.lowercased(),
                                                  "reversed_full_name": user.displayName?.components(separatedBy: " ")
                                                    .reversed().joined(separator: "")]])
    }
}
