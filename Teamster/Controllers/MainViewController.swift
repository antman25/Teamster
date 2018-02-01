//
//  MainViewController.swift
//  Teamster
//
//  Created by Anthony Magner on 1/20/18.
//  Copyright © 2018 Anthony Magner. All rights reserved.
//

import UIKit
import SideMenu
import Koloda
import FirebaseAuth
import Kingfisher

private var numberOfCards: Int = 5

class MainViewController: UIViewController {

   
    @IBOutlet weak var kolodaView: KolodaView!
    
    
    var dataSource: [CardView] = {
        var array: [CardView] = []
        for index in 0..<numberOfCards {
            var testView = CardView()
            //testView.frame = CGRect.zero
            if (index == 0){
                testView.imageView.image = UIImage(named: "ant")
               
                
                
            } else if (index == 1)
            {
                testView.imageView.image = UIImage(named: "steph")
            }
            
            array.append(testView)
        }
        return array
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSideMenu()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        // Do any additional setup after loading the view.
        
        print("URL: \(String(describing: Auth.auth().currentUser?.photoURL))")
    }
    
    fileprivate func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.default.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as? UISideMenuNavigationController
        
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuPresentMode = .viewSlideInOut
        SideMenuManager.default.menuWidth = view.frame.width * 0.7
        let styles:[UIBlurEffectStyle] = [.dark, .light, .extraLight]
        //SideMenuManager.default.menuBlurEffectStyle = styles[1]
        SideMenuManager.default.menuAnimationFadeStrength = 0.5
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func logoutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
        }
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        appDel.window?.rootViewController = TeamsterSignInViewController()
    }
    

}

extension MainViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        //let position = kolodaView.currentCardIndex
        //for i in 1...4 {
        //    dataSource.append(UIImage(named: "ant")!)
        // }
        //kolodaView.insertCardAtIndexRange(position..<position + 4, animated: true)
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        //UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
        print("Test")
    }
    
}

// MARK: KolodaViewDataSource

extension MainViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dataSource.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return dataSource[Int(index)]
    }
    
    //func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
    //    return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    // }
}
