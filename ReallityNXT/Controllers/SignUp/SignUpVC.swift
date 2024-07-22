//
//  SignUpVC.swift
//  ReallityNXT
//
//  Created by Jonish Sangwan on 17/06/24.
//

import UIKit

enum LoginTo{
    case social
    case other
}

class SignUpVC: UIViewController {

    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var builderImg: UIImageView!
    @IBOutlet weak var investorImg: UIImageView!
    @IBOutlet weak var individualImg: UIImageView!
    @IBOutlet weak var agentImg: UIImageView!
    @IBOutlet weak var builderLbl: UILabel!
    @IBOutlet weak var investorLbl: UILabel!
    @IBOutlet weak var individualLbl: UILabel!
    @IBOutlet weak var agentLbl: UILabel!
    @IBOutlet weak var agreeAndContinueBtn: UIButton!
    @IBOutlet weak var agreeImageIcon: UIImageView!
    
    var type: String?
    var mobileNumber: String?
    var user: User?
    var loginTo: LoginTo = .other
    var emailAddress:String?
    var socialname:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        agreeAndContinueBtn.isUserInteractionEnabled = false
        agreeAndContinueBtn.alpha = 0.4
        nameTF.isUserInteractionEnabled = loginTo == .other ? true : false
        emailTF.isUserInteractionEnabled = loginTo == .other ? true : false
        if loginTo == .social{
            nameTF.text = socialname
            emailTF.text = emailAddress
        }
    }

    @IBAction func didTapOnCategoryType(_ sender: UIButton){
        
        switch sender.tag {
        case 1:
            investorImg.image = UIImage(named: "invester_s")
            builderImg.image = UIImage(named: "builder-gray")
            agentImg.image = UIImage(named: "agent-gray")
            individualImg.image = UIImage(named: "individual-gray")
            
            investorLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            builderLbl.textColor = .black
            agentLbl.textColor = .black
            individualLbl.textColor = .black
            
            self.type = "1"
        case 2:
            investorImg.image = UIImage(named: "invester_gray")
            builderImg.image = UIImage(named: "builder-gray")
            agentImg.image = UIImage(named: "agent_s")
            individualImg.image = UIImage(named: "individual-gray")
            
            investorLbl.textColor = .black
            builderLbl.textColor = .black
            agentLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            individualLbl.textColor = .black
            
            self.type = "2"
        case 3:
            investorImg.image = UIImage(named: "invester_gray")
            builderImg.image = UIImage(named: "builder-gray")
            agentImg.image = UIImage(named: "agent-gray")
            individualImg.image = UIImage(named: "individual_s")
            
            investorLbl.textColor = .black
            builderLbl.textColor = .black
            agentLbl.textColor = .black
            individualLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.type = "3"
        default:
            investorImg.image = UIImage(named: "invester_gray")
            builderImg.image = UIImage(named: "builder_s")
            agentImg.image = UIImage(named: "agent-gray")
            individualImg.image = UIImage(named: "individual-gray")
            
            investorLbl.textColor = .black
            builderLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            agentLbl.textColor = .black
            individualLbl.textColor = .black
            
            self.type = "4"
        }
    }

    @IBAction func didTapOnContinue(_ sender: UIButton){
        
        if nameTF.text == ""{
            Toast.show(text: "Please enter name.", type: .info)
            return
        }else if emailTF.text == ""{
            Toast.show(text: "Please enter email.", type: .info)
            return
        }else if type == nil{
            Toast.show(text: "Please select your role.", type: .info)
            return
        }
        
        var dict = [String: Any]()
        dict["name"] = nameTF.text
        dict["email"] = emailTF.text
        dict["roleId"] = self.type
        
        
        if loginTo == .other{
            dict["mobile"] = mobileNumber
            dict["id"] = self.user?.id == nil ? 0 : self.user?.id
            if Connectivity.isConnectedToInternet {
                WebService.shared.updateUser(data: dict) { result in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "RootStackTabViewController") as! RootStackTabViewController
                        vc.user = result
                        Utility.shared.user = result
                        UserDefaults.standard.set(result?.toJSON(), forKey: "userProfile")
                        self.navigationController?.pushViewController(vc, animated: true)
                } failure: { error in
                    self.stopAnimation()
                    Toast.show(text: error?.localizedDescription, type: .info)
                }
            } else {
                self.stopAnimation()
                Toast.show(text: APP_MESSAGES.noInternetMessage, type: .info)
            }
        }else{
            dict["id"] = 0
            dict["mobile"] = "0"
            dict["deviceType"] = "iOS"
            dict["fbToken"] = "abcdf"
            dict["deviceId"] = UIDevice.current.identifierForVendor?.uuidString
            if Connectivity.isConnectedToInternet {
                WebService.shared.socialRegistration(data: dict) { result in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "RootStackTabViewController") as! RootStackTabViewController
                        vc.user = result
                        Utility.shared.user = result
                        UserDefaults.standard.set(result?.toJSON(), forKey: "userProfile")
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
    
    @IBAction func didTapOnAgreeBtn(_ sender: UIButton){
        
        if agreeAndContinueBtn.isUserInteractionEnabled == false{
            agreeAndContinueBtn.isUserInteractionEnabled = true
            agreeAndContinueBtn.alpha = 1.0
            agreeImageIcon.image = UIImage(named: "check")
        }else{
            agreeAndContinueBtn.isUserInteractionEnabled = false
            agreeAndContinueBtn.alpha = 0.4
            agreeImageIcon.image = UIImage(named: "uncheck")
        }
        
    }
}
