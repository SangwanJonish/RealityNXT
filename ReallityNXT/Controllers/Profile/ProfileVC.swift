//
//  ProfileVC.swift
//  ReallityNXT
//
//  Created by Jonish Sangwan on 21/06/24.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    static var newInstance: ProfileVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "ProfileVC"
        ) as! ProfileVC
        return vc
    }
    var profileUIModel: [ProfileUIModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getProfileUIData()
    }
    
    func getProfileUIData() {
        profileUIModel.append(ProfileUIModel(logoImage: #imageLiteral(resourceName: "profile"), titletext: "Personal Info", subtitleText: "View Personal Info"))
        profileUIModel.append(ProfileUIModel(logoImage: #imageLiteral(resourceName: "listing"), titletext: "Manage Listings", subtitleText: "Manage/Edit your Listings"))
        profileUIModel.append(ProfileUIModel(logoImage: #imageLiteral(resourceName: "delete"), titletext: "Delete Account", subtitleText: "Delete your Account from app"))
        profileUIModel.append(ProfileUIModel(logoImage: #imageLiteral(resourceName: "password"), titletext: "Change Password", subtitleText: "Change your Password"))
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func didTapOnPrivacyBtn(_ sender: Any) {
    }
    
    @IBAction func didTapOnLogoutBtn(_ sender: Any) {
    }

}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileUIModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableCell", for: indexPath) as! ProfileTableCell
        let obj = profileUIModel[indexPath.row]
        cell.assigndata(obj)
        return cell
    }
}

class ProfileTableCell:UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    
    func assigndata(_ obj: ProfileUIModel){
        
        self.titleLabel.text = obj.titletext
        self.subTitleLabel.text = obj.subtitleText
        self.logoImage.image = obj.logoImage
    }
}


struct ProfileUIModel{
    var logoImage: UIImage?
    var titletext: String?
    var subtitleText: String?
}
