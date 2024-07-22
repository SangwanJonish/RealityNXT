import Foundation
import SwiftMessages

class Toast {

  class func show(text: String?,type: Theme,changeBackground:Bool = false){
    let view = MessageView.viewFromNib(layout: .cardView)

    // Theme message elements with the warning style.
    view.configureTheme(type)
//    let isUserLoggedIn = UserSingleton.shared.loggedInUser?.data?.accessToken != nil

      view.configureTheme(backgroundColor: (changeBackground ? UIColor.black : lightColor) ?? GREEN_COLOR, foregroundColor:(changeBackground ? orangeColor : orangeColor) ?? UIColor.black)
    view.frame.size.height = 80
//    view.titleLabel?.font = R.font.sfProTextBold(size: 16)
//    view.bodyLabel?.font = R.font.sfProTextRegular(size: 14)

    view.button?.isHidden = true
//Validation.Alert Validation.Success
    view.configureContent(title:type == Theme.error ? "".localizedString : "".localizedString, body: /text, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "OK") { (button) in
      SwiftMessages.hide()
    }

    SwiftMessages.defaultConfig.presentationStyle = .bottom

    SwiftMessages.defaultConfig.presentationContext = .window(windowLevel: UIWindow.Level.alert)

    // Disable the default auto-hiding behavior.
    SwiftMessages.defaultConfig.duration = .automatic

    // Dim the background like a popover view. Hide when the background is tapped.
    //SwiftMessages.defaultConfig.dimMode = .gray(interactive: true)
    SwiftMessages.defaultConfig.dimMode = .none

    // Disable the interactive pan-to-hide gesture.
    SwiftMessages.defaultConfig.interactiveHide = true

    // Specify a status bar style to if the message is displayed directly under the status bar.
    SwiftMessages.defaultConfig.preferredStatusBarStyle = .none
    // Show message with default config.
    SwiftMessages.show(view: view)

    // Customize config using the default as a base.
    var config = SwiftMessages.defaultConfig
    config.duration = .forever

    // Show the message.
    SwiftMessages.show(config: config, view: view)
  }
}
