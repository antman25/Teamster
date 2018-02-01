//
//  TeamsterAuthViewController.swift
//  Teamster
//
//  Created by Anthony Magner on 1/23/18.
//  Copyright © 2018 Anthony Magner. All rights reserved.
//

import UIKit
import FirebaseAuthUI

class TeamsterAuthPickerViewController: FUIAuthPickerViewController {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    var initialOffset:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.alpha = 0
        appNameLabel.alpha = 0
        //viewConfigurations()
    }
    
    private func viewConfigurations() {
        
        addObservers()
        configureChildVCs()
        scrollView.delegate = self
    }
    
    @IBAction func loginTest1(_ sender: UIButtonX) {
        Auth.auth().signIn(withEmail: "test@test.com", password: "testtest") { (user, error) in
            print("user: \(user?.email)")
            print("error: \(error)")
        }
    }
    
    @IBAction func loginTest2(_ sender: UIButtonX) {
        Auth.auth().signIn(withEmail: "test2@test.com", password: "testtest") { (user, error) in
            print("user: \(user?.email)")
            print("error: \(error)")
        }
    }
    
    private func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(startAnimating), name:NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, animations: {
            self.backgroundImage.alpha = 1.0
        }) { (true) in
            //
            UIView.animate(withDuration: 0.5, animations: {
                self.appNameLabel.alpha = 1.0
            }, completion: { (true) in
                
            })
        }
        startAnimating()
    }
    
    
    
    @objc
    func startAnimating(){
        
        if backgroundImage.layer.animation(forKey: "center") == nil {
            backgroundImage.layer.add(animationForXAxis(), forKey: "center")
        }
    }
    
    func animationForXAxis() -> CABasicAnimation {
        
        let animation:CABasicAnimation = CABasicAnimation()
        animation.keyPath = "position.x"
        animation.byValue = 30
        animation.duration = 10.0
        animation.autoreverses = true
        animation.repeatCount = MAXFLOAT
        
        return animation
    }
    
    private func configureChildVCs(){
        
        let totalVCs = 3
        pageControl.numberOfPages = totalVCs
        
        for index in 0 ..< totalVCs {
            let childVC:TeamsterInfoViewController = childVCFor(index: index)
            addInScrollView(childVC:childVC)
        }
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width * CGFloat(totalVCs), height: UIScreen.main.bounds.size.height)
        print("Setting content size: \(scrollView.contentSize)")
        print("Frame size: \(scrollView.frame)")
    }
    
    private func childVCFor(index:NSInteger) -> TeamsterInfoViewController {
        
        let childVC = TeamsterInfoViewController(nibName: "TeamsterInfoPage\(index)", bundle: nil)
        
        var rect:CGRect = UIScreen.main.bounds
        rect.origin.x = CGFloat(index) * rect.size.width;
        childVC.view.frame = rect
        
        return childVC
    }
    
    private func addInScrollView(childVC:TeamsterInfoViewController){
        
        childVC.willMove(toParentViewController: self)
        scrollView.addSubview(childVC.view)
        childVC.didMove(toParentViewController: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension TeamsterAuthPickerViewController: UIScrollViewDelegate{
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var center = backgroundImage.center
        center.x = center.x - (scrollView.contentOffset.x - initialOffset)/3
        backgroundImage.center = center
        
        initialOffset = scrollView.contentOffset.x
        print ("test")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = NSInteger(scrollView.contentOffset.x)/NSInteger(scrollView.frame.size.width)
    }
    
}
