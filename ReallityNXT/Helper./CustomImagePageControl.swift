//
//  CustomImagePageControl.swift
//  JanSahayak
//
//  Created by Jonish Sangwan on 06/06/22.
//  Copyright © 2022 Jonish Sangwan. All rights reserved.
//

import UIKit

class CustomImagePageControl: UIPageControl {
    
    let activeImage:UIImage = UIImage(named: "slide-selected")!
    let inactiveImage:UIImage = UIImage(named: "slider-unselected")!

    override func awakeFromNib() {
          super.awakeFromNib()

          self.pageIndicatorTintColor = UIColor.clear
          self.currentPageIndicatorTintColor = UIColor.clear
          self.clipsToBounds = false
     }

     func updateDots() {
          var i = 0
          for view in self.subviews {
              if let imageView = self.imageForSubview(view) {
                  if i == self.currentPage {
                      imageView.image = self.activeImage
                  } else {
                      imageView.image = self.inactiveImage
                  }
                  i = i + 1
              } else {
                  var dotImage = self.inactiveImage
                  if i == self.currentPage {
                      dotImage = self.activeImage
                  }
                  view.clipsToBounds = false
                  view.addSubview(UIImageView(image:dotImage))
                  i = i + 1
              }
          }
      }

      fileprivate func imageForSubview(_ view:UIView) -> UIImageView? {
          var dot:UIImageView?

          if let dotImageView = view as? UIImageView {
              dot = dotImageView
          } else {
              for foundView in view.subviews {
                  if let imageView = foundView as? UIImageView {
                      dot = imageView
                      break
                  }
              }
          }

          return dot
      }
  }
