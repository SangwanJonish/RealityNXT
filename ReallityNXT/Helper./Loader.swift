//
//  HomeVC.swift
//  JanSahayak
//
//  Created by Jonish Sangwan on 29/12/20.
//  Copyright © 2020 Jonish Sangwan. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController{
   func startAnimation(){
    DispatchQueue.main.async(execute: { [self] in
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .annularDeterminate
        hud.label.text = "Loading"
        hud.label.textColor = #colorLiteral(red: 0.9369999766, green: 0.4860000014, blue: 0, alpha: 1)
        hud.animationType = .zoomOut
        hud.bezelView.color = #colorLiteral(red: 1, green: 0.9219999909, blue: 0.8309999704, alpha: 1)
        hud.backgroundView.style = .solidColor
    })
  }
    
    func stopAnimation(){
        DispatchQueue.main.async(execute: { [self] in
            MBProgressHUD.hide(for: view, animated: true)
        })
    }
}

@available(iOS 13.0, *)
extension UIViewController{
 
    func loader() -> UIAlertController {
            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.large
            loadingIndicator.startAnimating()
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            return alert
        }
        
        func stopLoader(loader : UIAlertController) {
            DispatchQueue.main.async {
                loader.dismiss(animated: true, completion: nil)
            }
        }
}
