//
//  CardView.swift
//  Teamster
//
//  Created by Anthony Magner on 1/21/18.
//  Copyright © 2018 Anthony Magner. All rights reserved.
//

import UIKit

class CardView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var infoHeight: NSLayoutConstraint!
    
    @IBOutlet weak var infoView: UIViewX!
    @IBOutlet weak var imageView: UIImageView!
    
    var infoShowing = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        //print("program: \(frame)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        //print("Storyborad")
    }
    
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        //view.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(view)
        
        contentView = view
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        infoView.addGestureRecognizer(tap)
        
    }
    
    func loadViewFromNib() -> UIView? {
        //guard let nibName = nibName else { return nil }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CardView", bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
    
    @objc
    func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
        if (infoShowing == false)
        {
            UIView.animate(withDuration: 0.3) {
                self.infoHeight.constant = 300
                self.contentView.layoutIfNeeded()
            }
            
            infoShowing = true
        }
        else
        {
            UIView.animate(withDuration: 0.3) {
                self.infoHeight.constant = 150
                self.contentView.layoutIfNeeded()
            }
            infoShowing = false
        }
        
        
    }
}
