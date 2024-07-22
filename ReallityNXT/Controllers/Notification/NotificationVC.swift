//
//  NotificationVC.swift
//  ReallityNXT
//
//  Created by Jonish Sangwan on 21/06/24.
//

import UIKit

class NotificationVC: UIViewController {
    
    static var newInstance: NotificationVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "NotificationVC"
        ) as! NotificationVC
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}
