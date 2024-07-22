//
//  BottomSheetPopUpForSelectCameraGallry.swift
//  ReallityNXT
//
//  Created by Jonish Sangwan on 12/07/24.
//

import UIKit

class BottomSheetPopUpForSelectCameraGallry: UIViewController {

    @IBOutlet weak var containerView: UIView!

    var didTapCameraBlock:(()->Void)?
    var didTapGallaryBlock:(()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 24
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    @IBAction func didTapOutSideView(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapCameraButton(_ sender: Any) {
        didTapCameraBlock?()
        self.dismiss(animated: true)
    }

    @IBAction func didTapGallaryButton(_ sender: Any) {
        didTapGallaryBlock?()
        self.dismiss(animated: true)
    }
}
