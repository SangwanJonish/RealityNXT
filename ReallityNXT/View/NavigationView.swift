//
//  NavigationView.swift
//  JanSahayak
//
//  Created by Jonish Sangwan on 29/12/20.
//  Copyright © 2020 Jonish Sangwan. All rights reserved.
//

import UIKit

class NavigationView: UIView {
    @IBOutlet weak var menu: UIButton?
    @IBOutlet weak var menuIcon: UIImageView?
    @IBOutlet weak var done: UIButton?
    @IBOutlet weak var back: UIButton?
    @IBOutlet weak var mTitle: UILabel?
    @IBOutlet weak var layoutConstraintsNavBarHeight: NSLayoutConstraint?
    
    var menuTapBlock:(()->Void)?
    var doneTapBlock:(()->Void)?
    var backTapBlock:(()->Void)?
    var attchmentTapBlock:(()->Void)?
     var editProfile:(()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        //default navigation hieght
        adjustNavBarHeight()
        mTitle?.textColor = .white
        mTitle?.font = UIFont(name: "Ubuntu-Bold", size: 16)
        //self.backgroundColor = BLUE_COLOR
    }
    
    func adjustNavBarHeight() {
        guard let layoutConstraintsNavHeight = self.layoutConstraintsNavBarHeight else {return}
        layoutConstraintsNavHeight.constant = 0.0
        if #available(iOS 11.0, *) {
            if (UIDevice.current.hasNotch) {
                if (UIWindow.key?.safeAreaInsets.top) != nil {
                    layoutConstraintsNavHeight.constant = 59.0
                }
            }
        }
    }
    
    @IBAction func menuTap(sender:UIButton) {
        guard self.menuTapBlock !=  nil else {return}
        self.menuTapBlock!()
    }
    @IBAction func doneTap(sender:UIButton) {
        guard self.doneTapBlock !=  nil else {return}
        self.doneTapBlock!()
    }
    
    @IBAction func backTap(sender:UIButton) {
        guard self.backTapBlock !=  nil else {return}
        self.backTapBlock!()
    }
    @IBAction func attachmentTap(sender:UIButton) {
        guard self.attchmentTapBlock !=  nil else {return}
        self.attchmentTapBlock!()
    }
    
    @IBAction func editProfileTap(sender:UIButton) {
        guard self.editProfile !=  nil else {return}
        self.editProfile!()
    }
}
