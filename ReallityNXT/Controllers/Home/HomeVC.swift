//
//  HomeVC.swift
//  ReallityNXT
//
//  Created by Jonish Sangwan on 18/06/24.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var currentAddress: UILabel!
    
    var user: User?
    static var newInstance: HomeVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "HomeVC"
        ) as! HomeVC
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        appDelegate.navController = self.navigationController
        nameTF.text = "Hi, \(/Utility.shared.user?.name)"
        currentAddress.text = "Punjab"
        print("Hi, \(/user?.email)")
    }
    
    @IBAction func logoutBtnAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func postAddBtnAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BasicDetailVC") as? BasicDetailVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}
