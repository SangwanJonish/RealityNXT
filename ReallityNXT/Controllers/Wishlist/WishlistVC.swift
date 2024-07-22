//
//  WishlistVC.swift
//  ReallityNXT
//
//  Created by Jonish Sangwan on 21/06/24.
//

import UIKit

class WishlistVC: UIViewController {

    static var newInstance: WishlistVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "WishlistVC"
        ) as! WishlistVC
        return vc
    }
    @IBOutlet weak var txtInput: UITextField!
    var tagsArray:[String] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addTag(_ sender: AnyObject) {
           
        if txtInput.text?.count != 0 {
               tagsArray.append(txtInput.text!)
               createTagCloud(OnView: self.view, withArray: tagsArray as [AnyObject])
           }
       }
    
    func createTagCloud(OnView view: UIView, withArray data:[AnyObject]) {

            for tempView in view.subviews {
                if tempView.tag != 0 {
                    tempView.removeFromSuperview()
                }
            }
            
            var xPos:CGFloat = 15.0
            var ypos: CGFloat = 130.0
            var tag: Int = 1
            for str in data  {
                let startstring = str as! String
                let width = startstring.widthOfString()
                let checkWholeWidth = CGFloat(xPos) + CGFloat(width) + CGFloat(13.0) + CGFloat(25.5 )//13.0 is the width between lable and cross button and 25.5 is cross button width and gap to righht
                if checkWholeWidth > UIScreen.main.bounds.size.width - 30.0 {
                    //we are exceeding size need to change xpos
                    xPos = 15.0
                    ypos = ypos + 29.0 + 8.0
                }
                
                let bgView = UIView(frame: CGRect(x: xPos, y: ypos, width:width + 17.0 + 38.5 , height: 29.0))
                bgView.layer.cornerRadius = 8
                bgView.backgroundColor = UIColor.white
                let gradient = CAGradientLayer()
                    gradient.frame =  CGRect(origin: CGPoint.zero, size: bgView.frame.size)
                gradient.colors = [gradiantFirstColor.cgColor, gradiantSecondColor.cgColor]
                    let shape = CAShapeLayer()
                    shape.lineWidth = 2
                shape.cornerRadius = 8
                    shape.path = UIBezierPath(rect: bgView.bounds).cgPath
                    shape.strokeColor = UIColor.black.cgColor
                    shape.fillColor = UIColor.clear.cgColor
                    gradient.mask = shape
                bgView.layer.addSublayer(gradient)
                bgView.tag = tag
                
                let textlable = UILabel(frame: CGRect(x: 17.0, y: 0.0, width: width, height: bgView.frame.size.height))
                textlable.font = UIFont(name: "Poppins-Regular", size: 13.0)
                textlable.text = startstring
                textlable.textColor = UIColor.black
                bgView.addSubview(textlable)
                
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: bgView.frame.size.width - 2.5 - 23.0, y: 3.0, width: 23.0, height: 23.0)
                button.backgroundColor = UIColor.white
                button.layer.cornerRadius = CGFloat(button.frame.size.width)/CGFloat(2.0)
                button.setImage(UIImage(named: "cross"), for: .normal)
                button.tag = tag
                button.addTarget(self, action: #selector(removeTag(_:)), for: .touchUpInside)
                bgView.addSubview(button)
                xPos = CGFloat(xPos) + CGFloat(width) + CGFloat(17.0) + CGFloat(43.0)
                view.addSubview(bgView)
                tag = tag  + 1
            }
            
        }
        
    @objc func removeTag(_ sender: AnyObject) {
            tagsArray.remove(at: (sender.tag - 1))
            createTagCloud(OnView: self.view, withArray: tagsArray as [AnyObject])
        }

}
