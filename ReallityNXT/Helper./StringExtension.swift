//
//  HomeVC.swift
//  JanSahayak
//

//  Created by Jonish Sangwan on 29/12/20.
//  Copyright © 2020 Jonish Sangwan. All rights reserved.
//

import UIKit

extension String {
    func isValidEmail() -> Bool {
     let emailRegex = "\\A[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\z"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let result = emailTest.evaluate(with:self)
        return result
    }
    func isValidUsername() -> Bool {
        let userRegEx = "\\w{4,20}"
        let userTest = NSPredicate(format:"SELF MATCHES %@", userRegEx)
        let result = userTest.evaluate(with:self)
        return result
    }
    
    var stringByRemovingWhitespacesAndNewLines: String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.joined(separator: "")
    }
    
    var url: URL? {
        return URL(string: self)
    }
    func rangeOf(_ str: String) -> NSRange {
        return (self as NSString).range(of: str)
    }
    
}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension UICollectionView{
    
    func getVisibleIndexOnScroll()-> IndexPath?{
        
        var visibleRect = CGRect()
        visibleRect.origin = self.contentOffset
        visibleRect.size = self.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = self.indexPathForItem(at: visiblePoint)
        return indexPath
    }
    
    func registerNibCollectionCell(nibName:String,reuseIdentifier:String){
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func deselectAllItems(animated: Bool = false) {
        for indexPath in self.indexPathsForSelectedItems ?? [] {
            self.deselectItem(at: indexPath, animated: animated)
        }
    }
    
}
