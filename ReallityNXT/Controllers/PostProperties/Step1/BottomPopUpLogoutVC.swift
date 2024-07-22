//
//  BottomPopUpLogoutVC.swift
//  ReallityNXT
//
//  Created by Jonish Sangwan on 16/07/24.
//

import UIKit

class BottomPopUpLogoutVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var descLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 24
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        descLabel.text = "On changing account you will be logged out as \(/Utility.shared.user?.name). Do you want to log out?"
    }
    
    @IBAction func didTapOutSideView(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
        self.dismiss(animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        Utility.shared.user = nil
        UserDefaults.standard.removeObject(forKey: "userProfile")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        appDelegate.navController?.pushViewController(controller, animated: true)
    }

}
