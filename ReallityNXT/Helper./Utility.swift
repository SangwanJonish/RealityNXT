//
//  Utility.swift
//  Traveloo
//
//  Created by Charanjit Singh on 10/23/19.
//  Copyright © 2019 Charanjit Singh. All rights reserved.
//

import UIKit
import DropDown
import Foundation

typealias  dropDownSelectedIndex = (_ index: Int , _ strVal: String) -> ()

class Utility: NSObject {
    
    static let shared:Utility =  Utility()
    var window = UIWindow()
    var authorizationToken:String!
    var keyboard:String = "en"
    var fcmToken: String?
    var colorArr = [orangeColor,yellowColor,GreenColor]
    var colorIndex = 0
    var user: User?
    var propertyId = 0
    
    func showDropDown(anchorView : UIView , dataSource : [String] , width : CGFloat , handler : @escaping dropDownSelectedIndex, isOpenBelow: Bool? = false ) {
        
        let dropDown = DropDown()
        
        dropDown.anchorView = anchorView // UIView or UIBarButtonItem
        
        dropDown.dataSource = dataSource
        
        dropDown.selectionAction = { (index: Int, item: String) in
            handler(index, item)
        }
        if isOpenBelow == true {
            dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        }
        dropDown.width = width
        dropDown.show()
    }
    
    func shareApp() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let name = URL(string: "https://jansahayak.haryana.gov.in/appshare.aspx"), !name.absoluteString.isEmpty {
            
          let objectsToShare = [name]
          let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            //appDelegate.navController?.present(activityVC, animated: true, completion: nil)
        } else {
          // show alert for not available
        }
    }
    

    func downloadDocument(from url: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        let session = URLSession(configuration: .default)
        
        let downloadTask = session.downloadTask(with: url) { tempURL, _, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let temporaryURL = tempURL else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                
                let destinationURL = documentsURL.appendingPathComponent(url.lastPathComponent)
                
                try FileManager.default.moveItem(at: temporaryURL, to: destinationURL)
                
                completion(.success(destinationURL))
            } catch {
                completion(.failure(error))
            }
        }
        
        downloadTask.resume()
    }

    
}


extension CATransition {
    func popFromLeft() -> CATransition {
        self.duration = 0.3 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.reveal
        self.subtype = CATransitionSubtype.fromLeft
        return self
    }
}
