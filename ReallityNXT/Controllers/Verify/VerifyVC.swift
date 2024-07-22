//
//  VerifyVC.swift
//  ReallityNXT
//
//  Created by Jonish Sangwan on 17/06/24.
//

import UIKit

class VerifyVC: UIViewController {

    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var firstTxt: UITextField!
    @IBOutlet weak var secondTxt: UITextField!
    @IBOutlet weak var thirdTxt: UITextField!
    @IBOutlet weak var forthTxt: UITextField!
    
    @IBOutlet weak var firstSelection: UIImageView!
    @IBOutlet weak var secondSelection: UIImageView!
    @IBOutlet weak var thirdSelection: UIImageView!
    @IBOutlet weak var forthSelection: UIImageView!
    
    var mobileNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneNumberLbl.text = mobileNumber
        actionOnTextField()
    }
    
    func actionOnTextField() {
        
        firstTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        secondTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        thirdTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        forthTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    func verifyOtpApi() {
        guard let first = firstTxt.text,
            let second = secondTxt.text,
            let third = thirdTxt.text,
            let forth = forthTxt.text else {
            self.stopAnimation()
            Toast.show(text: "Enter valid OTP".localizedString, type: .info)
                return
        }
       
        if(first == "" || second == "" || third == "" || forth == ""){
            self.stopAnimation()
            Toast.show(text: "Enter valid OTP".localizedString, type: .info)
                return
        }
        
        let verificationCode = first + second + third + forth
        self.startAnimation()
       
        if Connectivity.isConnectedToInternet {
            var dict = [String: Any]()
            dict["otp"] = verificationCode
            dict["mobile"] = mobileNumber
            dict["deviceType"] = "iOS"
            dict["fbToken"] = "abcdf"
            dict["deviceId"] = UIDevice.current.identifierForVendor?.uuidString
            WebService.shared.verifyOtp(data: dict) { result in
                if result?.message == "Data not saved" || result?.message == "No Record found."{
                    //sign up
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
                    vc.mobileNumber = self.mobileNumber
                    vc.user = result?.data?.first
                    vc.loginTo = .other
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                   //Home
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "RootStackTabViewController") as! RootStackTabViewController
                    vc.user = result?.data?.first
                    Utility.shared.user = result?.data?.first
                    UserDefaults.standard.set(result?.data?.first?.toJSON(), forKey: "userProfile")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } failure: { error in
                self.stopAnimation()
                Toast.show(text: error?.localizedDescription, type: .info)
            }
        } else {
            self.stopAnimation()
            Toast.show(text: APP_MESSAGES.noInternetMessage, type: .info)
        }
      
    }
    
    func loginApi() {
        self.startAnimation()
        if Connectivity.isConnectedToInternet {
            var dict = [String: Any]()
            dict["phone"] = self.mobileNumber
            WebService.shared.loginApi(data: dict) { result in
                self.stopAnimation()
                Toast.show(text: APP_MESSAGES.resendOtp, type: .info)
            } failure: { error in
                self.stopAnimation()
                Toast.show(text: error?.localizedDescription, type: .info)
            }
        } else {
            self.stopAnimation()
            Toast.show(text: APP_MESSAGES.noInternetMessage, type: .info)
        }
    }
    
    @IBAction func didTapOnVerify(_ sender: Any) {
        verifyOtpApi()
    }
    
    @IBAction func didTapOnResend(_ sender: Any) {
        loginApi()
    }
    
    @IBAction func didTapOnChange(_ sender: Any) {
        
        self.pop(animated: true)
    }

}

extension VerifyVC : UITextFieldDelegate {
    
    
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        let textcount = text?.utf16.count ?? 0
        self.firstSelection.isHidden = false
        if textcount >= 1{
            switch textField{
                
            case firstTxt:
                self.secondSelection.image = UIImage(named: "TfShape")
                secondTxt.becomeFirstResponder()
            case secondTxt:
                self.thirdSelection.image = UIImage(named: "TfShape")
                thirdTxt.becomeFirstResponder()
            case thirdTxt:
                self.forthSelection.image = UIImage(named: "TfShape")
                forthTxt.becomeFirstResponder()
            case forthTxt:
                forthTxt.resignFirstResponder()
            default:
                break
            }
        } else {
            switch textField{
            case firstTxt:
                firstTxt.resignFirstResponder()
            case secondTxt:
                self.secondSelection.image = UIImage(named: "Empty")
                firstTxt.becomeFirstResponder()
            case thirdTxt:
                self.thirdSelection.image = UIImage(named: "Empty")
                secondTxt.becomeFirstResponder()
            case forthTxt:
                self.forthSelection.image = UIImage(named: "Empty")
                thirdTxt.becomeFirstResponder()
            default:
                break
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // get the current text, or use an empty string if that failed
            let currentText = textField.text ?? ""

            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }

            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
         
        return string == "" ? true : /updatedText.count == 1
    }
}
