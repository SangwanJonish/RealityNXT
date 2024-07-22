//
//  LoginVC.swift
//  ReallityNXT
//
//  Created by Jonish Sangwan on 03/06/24.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class LoginVC: UIViewController {
    
    
    @IBOutlet weak var btnGoogleSignIn: UIButton!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var phoneNumberTitleLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var flagImageBoarderView: UIImageView!
    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var countryListView: UIView!
    @IBOutlet weak var countryView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var countryArr = [Countries]()
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.getCountries()
        setView(view: self.countryListView, hidden: true)
        assignViewdata(bool: false)
    }
    
    @IBAction func contryPickerAction(_ sender: Any) {
        setView(view: self.countryListView, hidden: false)
        tableView.delegate = self
        tableView.dataSource = self
        let view = UIView()
        view.backgroundColor = .clear
        tableView.tableFooterView = view
        tableView.reloadData()
    }
    
    @IBAction func didTaploginButton(_ sender: Any) {
        
        if countryView.constant == 55{
            if selectedIndex == nil {
                Toast.show(text: "Please choose your country", type: .info)
                return
            }else if phoneNumberTF.text == "" || /phoneNumberTF.text?.count < 10{
                Toast.show(text: "Please enter the correct number.", type: .info)
                return
            }
        }else{
            if self.isValidEmail(email: /phoneNumberTF.text){
                Toast.show(text: "Please enter valid email", type: .info)
                return
            }
        }
        if countryArr.count > 0{
            loginApi()
        }else{
            Toast.show(text: APP_MESSAGES.technicalIssueMessage, type: .info)
        }
        
    }
    
    @IBAction func btnGoogleSingInDidTap(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            self.btnGoogleSignIn.isHidden = false
            guard error == nil else { return }
            
            // If sign in succeeded, display the app's main content View.
            guard let signInResult = signInResult else { return }
            let user = signInResult.user
            let emailAddress = user.profile?.email
            let fullName = user.profile?.name
            //let familyName = user.profile?.familyName
            //let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            self.checkUserAlreadyExit(name: fullName, email: emailAddress)
            self.btnGoogleSignIn.isHidden = true
        }
    }
    
    @IBAction func fbloginTap(_ sender: Any) {
        
        facebookLogin()
    }
    
    @IBAction func didTapOnEmailBtn(_ sender: Any) {
        assignViewdata(bool: true)
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
    
    func moveToSignUp(name: String?,email: String?){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        vc.socialname = name
        vc.emailAddress = email
        vc.loginTo = .social
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}" +
            "\\@" +
            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
            "(" +
            "\\." +
            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
            ")+"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return !emailPred.evaluate(with: email)
    }
    
    func assignViewdata(bool: Bool){
        
        phoneNumberTF.delegate = self
        countryView.constant = bool == true ? 0 : 55
        flagImageView.isHidden = bool
        countryNameLbl.isHidden = bool
        flagImageBoarderView.isHidden = bool
        phoneNumberTitleLabel.text = bool == true ? "Email" : "Mobile Number"
        phoneNumberTF.placeholder = bool == true ? "Enter your email" : "Enter your mobile number"
    }
    
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
    // Facebook login function
    
    func facebookLogin() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                // Handle login error here
                print("Error: \(error.localizedDescription)")
            } else if let result = result, !result.isCancelled {
                // Login successful, you can access the user's Facebook data here
                self.fetchFacebookUserData()
            } else {
                // Login was canceled by the user
                print("Login was cancelled.")
            }
        }
    }
    // MARK: - Fetch Facebook User Data
    
    func fetchFacebookUserData() {
        if AccessToken.current != nil {
            // You can make a Graph API request here to fetch user data
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start { (connection, result, error) in
                if let error = error {
                    // Handle API request error here
                    print("Error: \(error.localizedDescription)")
                } else if let userData = result as? [String: Any] {
                    // Access the user data here
                    let email = userData["email"] as? String
                    let name = userData["name"] as? String
                    self.checkUserAlreadyExit(name: name, email: email)
                    // Handle the user data as needed
                    print("User ID: \(email ?? "")")
                    print("Name: \(name ?? "")")
                    
                }
            }
        } else {
            print("No active Facebook access token.")
        }
    }
    
    func checkUserAlreadyExit(name: String?,email: String?) {
        self.startAnimation()
       
        if Connectivity.isConnectedToInternet {
            var dict = [String: Any]()
            dict["mobile"] = email
            WebService.shared.checkUserAlreadyExit(data: dict) { result in
                if result?.status == 200{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "RootStackTabViewController") as! RootStackTabViewController
                    vc.user = result?.data?.first
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.moveToSignUp(name: name, email: email)
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

    
    func getCountries() {
        self.startAnimation()
        if Connectivity.isConnectedToInternet {
            WebService.shared.getCountries(success: { (result) in
                self.stopAnimation()
                if let result = result {
                    self.countryArr = result
                    self.countryNameLbl.text = /self.countryArr.first?.code + "   " + /self.countryArr.first?.countryName
                    self.flagImageView.sd_setImage(with: URL(string: /self.countryArr.first?.url), placeholderImage:UIImage(contentsOfFile:"placeholder.png"))
                    self.selectedIndex = 0
                }else{
                    self.stopAnimation()
                    Toast.show(text: "Something Went Wrong", type: .info)
                }
            }, failure: { (error) in
                self.stopAnimation()
                Toast.show(text: error?.localizedDescription, type: .info)
            })
        } else {
            self.stopAnimation()
            Toast.show(text: APP_MESSAGES.noInternetMessage, type: .info)
        }
    }
    
    func loginApi() {
        self.startAnimation()
        if Connectivity.isConnectedToInternet {
            var dict = [String: Any]()
            dict["phone"] = self.phoneNumberTF.text
            WebService.shared.loginApi(data: dict) { result in
                self.stopAnimation()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "VerifyVC") as! VerifyVC
                if self.countryView.constant == 55{
                    ///self.countryArr[self.selectedIndex ?? 0].code +
                    vc.mobileNumber = "\(self.phoneNumberTF.text ?? "")"
                }else{
                    vc.mobileNumber = "\(self.phoneNumberTF.text ?? "")"
                }
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



extension LoginVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableCell", for: indexPath) as! CountryTableCell
        let obj = self.countryArr[indexPath.row]
        cell.assignData(obj)
        cell.check.isHidden = selectedIndex != indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.countryArr[indexPath.row]
        self.countryNameLbl.text = /obj.code + "   " + /obj.countryName
        self.flagImageView.sd_setImage(with: URL(string: /obj.url), placeholderImage:UIImage(contentsOfFile:"placeholder.png"))
        self.selectedIndex = indexPath.row
        self.setView(view: countryListView, hidden: true)
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }
}

extension LoginVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = Int(/textField.text?.count + string.count) - Int(range.length)
        
        if newLength > 10 {
            phoneNumberTF.resignFirstResponder()
            return false
        }
        return true
    }
}
