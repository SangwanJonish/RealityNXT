//
//  Extensions.swift
//  JanSahayak
//
//  Created by Jonish Sangwan on 28/12/20.
//  Copyright © 2020 Jonish Sangwan. All rights reserved.
//

import UIKit

extension String: Error {}

extension UIViewController {
    
    var rootVC: RootStackTabViewController? {
        var selfVC = self
        while let parentVC = selfVC.parent {
            if let vc = parentVC as? RootStackTabViewController {
                return vc
            } else {
                selfVC = parentVC
            }
        }
        return nil
    }
    
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

extension UIImageView {
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat,color: CGColor){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = color
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 10
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
}

extension UIButton{
    func roundedButton(btn: UIButton){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.topLeft , .topRight],
            cornerRadii: CGSize(width: 16, height: 16))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = btn.frame
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}

extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2
        datePicker.maximumDate = Date().getPreviousDate()
        // iOS 14 and above
        if #available(iOS 14, *) {// Added condition for iOS 14
          datePicker.preferredDatePickerStyle = .wheels
          datePicker.sizeToFit()
        }
        self.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}
extension Date {

    func getPreviousDate() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
}
extension UIButton{
  
  func bounce(){
    self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    UIView.animate(withDuration: 0.2,
                   delay: 0,
                   options: .allowUserInteraction,
                   animations: { [weak self] in
                    self?.transform = .identity
      },
                   completion: nil)
  }
  
  func transformContent(){
    self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    self.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    self.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
  }
  
  func setInsetsWithImage(){
    self.imageEdgeInsets = UIEdgeInsets(top: 0, left: self.frame.size.width - 24, bottom: 0, right: 0)
    self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: self.frame.size.width/2 + 16)
  }
  
  func addGradient(topColor:UIColor,bottomColor:UIColor,statPoint:CGPoint,endPoint:CGPoint){
    let gradient:CAGradientLayer = CAGradientLayer()
    let colorTop = topColor
    let colorBottom = bottomColor
    
    gradient.colors = [colorTop, colorBottom]
    gradient.startPoint = statPoint
    gradient.endPoint = endPoint
    gradient.frame = self.bounds
    gradient.cornerRadius = 5
    self.layer.insertSublayer(gradient, at: 0)
  }
}

//MARK: - String extension
extension String {
    
    //convert string to date
    static func convertStringToDate(strDate:String, dateFormate strFormate:String) -> Date{
      let dateFormate = DateFormatter()
      dateFormate.dateFormat = strFormate
      dateFormate.timeZone = TimeZone.init(abbreviation: "UTC")
      let dateResult:Date = dateFormate.date(from: strDate)!
      return dateResult
    }
    
    func isValidDouble(maxDecimalPlaces: Int) -> Bool {
        // Use NumberFormatter to check if we can turn the string into a number
        // and to get the locale specific decimal separator.
       
        let formatter = NumberFormatter()
        formatter.allowsFloats = true // Default is true, be explicit anyways
        let decimalSeparator = formatter.decimalSeparator ?? "."  // Gets the locale specific decimal separator. If for some reason there is none we assume "." is used as separator.
        
        // Check if we can create a valid number. (The formatter creates a NSNumber, but
        // every NSNumber is a valid double, so we're good!)
        if formatter.number(from: self) != nil {
            // Split our string at the decimal separator
            let split = self.components(separatedBy: decimalSeparator)
            
            // Depending on whether there was a decimalSeparator we may have one
            // or two parts now. If it is two then the second part is the one after
            // the separator, aka the digits we care about.
            // If there was no separator then the user hasn't entered a decimal
            // number yet and we treat the string as empty, succeeding the check
            let digits = split.count == 2 ? split.last ?? "" : ""
            
            // Finally check if we're <= the allowed digits
            return digits.count <= maxDecimalPlaces    // TODO: Swift 4.0 replace with digits.count, YAY!
        }
        
        return false // couldn't turn string into a valid number
    }
    
    func getTwoDecimalFloat() -> String {
      return  String(format: "%.02f", self.floatValue)
        
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    var localizedString : String {
         return NSLocalizedString(self, comment:"")
    }
  
  func directTextHeight(textFont : UIFont?) -> CGFloat {
    
    guard let font = textFont else { return 0.0 }
    let width = UIScreen.main.bounds.width - 100
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
    return boundingBox.height
  }
  
  //string to date
  func stringToDate(_ date:String , format:String)->Date  {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format //Your date format
    let date1 = dateFormatter.date(from: String(date)) //according to date format your date string
    return date1 ?? Date()
    
  }
  
    
    func getLocalDate() -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.date(from: self)
        
    }
  
  func validateUrl () -> Bool {
    let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
    return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self)
  }
  
  
  func widthOfString() -> CGFloat {
    
    let fontAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 13)]
    let size = self.size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
    return size.width
  }
    
    func openAppStore() {
        
          if let url = URL(string: self), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:]) { (result) in
                }
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
   
}

extension AppDelegate {
    
    class func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

extension UIDevice {
    var hasNotch: Bool {
        var bottom: CGFloat = 0
        if #available(iOS 11.0, *) {
            bottom = UIWindow.key?.safeAreaInsets.bottom ?? 0
        } else {
            print("for lower ios version")
        }
        return bottom > 0
    }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}

extension UIViewController {
    
    /// An alert view
    func showAlert(title: String?, message: String?) {
        showAlert(title: title, message: message) { _ in ()
            
        }
    }
    
    func convertDateFormater(_ date: String,current: String,new: String) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = current
            let dateFormatterNew = DateFormatter()
            dateFormatterNew.dateFormat = new
            guard let date = dateFormatter.date(from: date) else {return ""}
            return  dateFormatterNew.string(from: date)
        }
    
    func getDateFromString(dateStr: String) -> (date: Date?,conversion: Bool)
    {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dateComponentArray = dateStr.components(separatedBy: "/")

        if dateComponentArray.count == 3 {
            var components = DateComponents()
            components.year = Int(/dateComponentArray[2].components(separatedBy: " ").first)
            components.month = Int(dateComponentArray[0])
            components.day = Int(dateComponentArray[1])
            components.timeZone = TimeZone(abbreviation: "GMT+0:00")
            guard let date = calendar.date(from: components) else {
                return (nil , false)
            }

            return (date,true)
        } else {
            return (nil,false)
        }

    }
    func showAlert(title: String?, message: String?, completionAction:@escaping (_ status: Bool) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localizedString, style: .default, handler: { (action) in
                completionAction(true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel".localizedString, style: .default, handler: { (action) in
                completionAction(false)
            }))
            alert.view.tintColor = #colorLiteral(red: 0.9369999766, green: 0.4860000014, blue: 0, alpha: 1)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func callInitiate(phone: String){
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
//    func showAlertOnWindow(title: String?, message: String?) {
//        showAlertOnWindow(title: title, message: message) { () in
//            
//        }
//    }
    
//    func showAlertOnWindow(title: String?, message: String?, completionAction:@escaping () -> Void) {
//        DispatchQueue.main.async {
//            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                completionAction()
//            }))
//            alert.show(<#UIViewController#>, sender: <#Any?#>)
//        }
//    }
    
//    func showAlertOnWindowWithCancleButton(title: String?, message: String?, okTitle: String?, cancelTitle: String?, completionAction:@escaping (_ isOk: Bool) -> Void) {
//        DispatchQueue.main.async {
//            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: { (action) in
//                completionAction(true)
//            }))
//            alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: { (action) in
//                completionAction(false)
//            }))
//            alert.show()
//        }
//    }
    
    
    func showAlert(title: String?, message: String?, okTitle: String?, cancelTitle: String?, completionAction:@escaping (_ isOk: Bool) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: { (action) in
                completionAction(true)
            }))
            alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: { (action) in
                completionAction(false)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func showAlertWithTextField(title: String?, message: String?, okTitle: String?, cancelTitle: String?, completionAction:@escaping (_ isOk: Bool) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Password"
            })
            
            alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: { (action) in
                completionAction(true)
            }))
            alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: { (action) in
                completionAction(false)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showToast(message : String) {
        
        //let toastLabel = UILabel(frame: CGRect(x: (self.view.frame.size.width-225)/2 , y: self.view.frame.size.height-100, width: 250, height: 40))
        let toastLabel = UILabel(frame: CGRect(x: 8 , y: self.view.frame.size.height-100, width: self.view.frame.size.width - 16, height: 40))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6) //UIColor(displayP3Red: 255/255, green: 189/255, blue: 50/255, alpha: 1.0)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        if let font = UIFont(name: "Raleway-Light", size: 10.0) {
            toastLabel.font = font
        }
        toastLabel.numberOfLines = 0
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        //AppDelegate.shared.window.last.addSubview(toastLabel)
        UIApplication.shared.windows.last?.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func push(_ controller: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(controller, animated: animated)
    }
    
    func pop(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    func noDataFoundLbl(table: UITableView){
        
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: table.bounds.size.width, height: table.bounds.size.height))
        noDataLabel.text = "No Data Available"
        noDataLabel.textColor = orangeColor
        noDataLabel.textAlignment = NSTextAlignment.center
        table.backgroundView = noDataLabel
    }
    
    func noDataFoundLbl(table: UICollectionView){
        
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: table.bounds.size.width, height: table.bounds.size.height))
        noDataLabel.text = "No Data Available"
        noDataLabel.textColor = orangeColor
        noDataLabel.textAlignment = NSTextAlignment.center
        table.backgroundView = noDataLabel
    }
}


let YYYY_MM_DD_HH_MM_SS_zzzz = "yyyy-MM-dd HH:mm:ss +zzzz"
let YYYY_MM_DD_HH_MM_SS = "yyyy-MM-dd HH:mm:ss"
let DD_MM_YYYY = "dd-MM-yyyy"
let MM_DD_YYYY = "MM-dd-yyyy"
let YYYY_DD_MM = "yyyy-dd-MM"
let YYYY_MM_DD_T_HH_MM_SS = "yyyy-MM-dd'T'HH:mm:ss"
let YYYY_MM_DDTHH_MM_SS = "yyyy-MM-dd HH:mm:ss"
let DD_MMM_YYYY = "dd MMM"
let YYYY_MM_DD = "yyyy-MM-dd"
let MM_dd_yyyy = "MM/dd/yyyy HH:mm:ss a"

extension Date{

  //Function for old date format to new format from UTC to local
  static func convertDateUTCToLocal(strDate:String, oldFormate strOldFormate:String, newFormate strNewFormate:String) -> String{
    let dateFormatterUTC:DateFormatter = DateFormatter()
    dateFormatterUTC.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?//set UTC timeZone
    dateFormatterUTC.dateFormat = strOldFormate //set old Format
    if let oldDate:Date = dateFormatterUTC.date(from: strDate)  as Date?//convert date from input string
    {
      dateFormatterUTC.timeZone = NSTimeZone.local//set localtimeZone
      dateFormatterUTC.dateFormat = strNewFormate //make new dateformatter for output format
      if let strNewDate:String = dateFormatterUTC.string(from: oldDate as Date) as String?//convert dateInUTC into string and set into output
      {
        return strNewDate
      }
      return strDate
    }
    return strDate
  }

  //Convert without UTC to local
  static func convertDateToLocal(strDate:String, oldFormate strOldFormate:String, newFormate strNewFormate:String) -> String{
    let dateFormatterUTC:DateFormatter = DateFormatter()
    //set local timeZone
    dateFormatterUTC.dateFormat = strOldFormate //set old Format
    if let oldDate:Date = dateFormatterUTC.date(from: strDate) as Date?//convert date from input string
    {
      dateFormatterUTC.timeZone = NSTimeZone.local
      dateFormatterUTC.dateFormat = strNewFormate //make new dateformatter for output format
      if let strNewDate = dateFormatterUTC.string(from: oldDate as Date) as String?//convert dateInUTC into string and set into output
      {
        return strNewDate
      }
      return strDate
    }
    return strDate
  }

  //Convert Date to String
  func convertDateToString(strDateFormate:String) -> String{
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = strDateFormate
      let strDate = dateFormatter.string(from: self)
//      dateFormatter = nil
      return strDate
  }


  //Convert local to utc
  static func convertLocalToUTC(strDate:String, oldFormate strOldFormate:String, newFormate strNewFormate:String) -> String{
    let dateFormatterUTC:DateFormatter = DateFormatter()
    dateFormatterUTC.timeZone = NSTimeZone.local as TimeZone?//set UTC timeZone
    dateFormatterUTC.dateFormat = strOldFormate //set old Format
    if let oldDate:Date = dateFormatterUTC.date(from: strDate)  as Date?//convert date from input string
    {
      dateFormatterUTC.timeZone = NSTimeZone.init(abbreviation: "UTC")! as TimeZone//set localtimeZone
      dateFormatterUTC.dateFormat = strNewFormate //make new dateformatter for output format
      if let strNewDate:String = dateFormatterUTC.string(from: oldDate as Date) as String?//convert dateInUTC into string and set into output
      {
        return strNewDate
      }
      return strDate
    }
    return strDate
  }

  //Comparison two date
  static func compare(date:Date, compareDate:Date) -> String{
    var strDateMessage:String = ""
    let result:ComparisonResult = date.compare(compareDate)
    switch result {
    case .orderedAscending:
      strDateMessage = "Future Date"
      break
    case .orderedDescending:
      strDateMessage = "Past Date"
      break
    case .orderedSame:
      strDateMessage = "Same Date"
      break
    default:
      strDateMessage = "Error Date"
      break
    }
    return strDateMessage
  }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
