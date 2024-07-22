//
//  WelcomeVC.swift
//  ReallityNXT
//
//  Created by Jonish Sangwan on 03/06/24.
//

import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet weak var signUpButton: UIButton! {
        didSet{
            signUpButton.backgroundColor = .clear
            signUpButton.layer.cornerRadius = 10
            signUpButton.layer.borderWidth = 1
            signUpButton.layer.borderColor = #colorLiteral(red: 0.7607843137, green: 0.7803921569, blue: 0.8196078431, alpha: 1)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func skipBtnAction(_ sender: Any) {
        guestUserRegistration()
    }
    
    func guestUserRegistration() {
        self.startAnimation()
        if Connectivity.isConnectedToInternet {
            var dict = [String: Any]()
            dict["deviceType"] = "iOS"
            dict["fbToken"] = "abcdf"
            dict["deviceId"] = UIDevice.current.identifierForVendor?.uuidString
            dict["roleId"] = "3"
            WebService.shared.guestUserRegistration(data: dict) { result in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "RootStackTabViewController") as! RootStackTabViewController
                    vc.user = result?.data?.first
                    self.navigationController?.pushViewController(vc, animated: true)
            } failure: { error in
                self.stopAnimation()
                Toast.show(text: error?.localizedDescription, type: .info)
            }
        } else {
            self.stopAnimation()
            Toast.show(text: APP_MESSAGES.noInternetMessage, type: .info)
        }
      
    }
}
