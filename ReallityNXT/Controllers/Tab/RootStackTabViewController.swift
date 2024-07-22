//
//  RootStackTabViewController.swift
//  MYTabBarDemo
//
//  Created by Abhishek Thapliyal on 30/05/20.
//  Copyright © 2020 Abhishek Thapliyal. All rights reserved.
//

import UIKit

class RootStackTabViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomStack: UIStackView!
    
    var currentIndex = 0
    var main: UIStoryboard{
        return UIStoryboard(name: "Main", bundle: nil)
    }
    var user: User?
    
    lazy var tabs: [StackItemView] = {
        var items = [StackItemView]()
        for _ in 0..<5 {
            items.append(StackItemView.newInstance)
        }
        return items
    }()
    
    lazy var tabModels: [BottomStackItem] = {
        return [
            BottomStackItem(title: "Home", image: "Home"),
            BottomStackItem(title: "Wishlist", image: "Wishlist"),
            BottomStackItem(title: "Notification", image: "Notification"),
            BottomStackItem(title: "Profile", image: "Profile"),
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()
        let vc = HomeVC.newInstance
        addChild(vc)
        containerView.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        vc.view.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        vc.view.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
    }

    func setupTabs() {
        for (index, model) in self.tabModels.enumerated() {
            let tabView = self.tabs[index]
            model.isSelected = index == 0
            tabView.item = model
            tabView.delegate = self
            self.bottomStack.addArrangedSubview(tabView)
        }
    }
    
    
}

extension RootStackTabViewController: StackItemViewDelegate {
    
    func handleTap(_ view: StackItemView) {
        self.tabs[self.currentIndex].isSelected = false
        view.isSelected = true
        self.currentIndex = self.tabs.firstIndex(where: { $0 === view }) ?? 0
        
        switch self.currentIndex {
        case 0:
            let vc = HomeVC.newInstance
            addChild(vc)
            containerView.addSubview(vc.view)
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            vc.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            vc.view.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
            vc.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            vc.view.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        case 1:
            let vc = WishlistVC.newInstance
            addChild(vc)
            HomeVC.newInstance.removeFromParent()
            containerView.addSubview(vc.view)
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            vc.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            vc.view.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
            vc.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            vc.view.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        case 2:
            let vc = NotificationVC.newInstance
            addChild(vc)
            containerView.addSubview(vc.view)
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            vc.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            vc.view.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
            vc.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            vc.view.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        default:
            let vc = ProfileVC.newInstance
            addChild(vc)
            containerView.addSubview(vc.view)
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            vc.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            vc.view.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
            vc.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            vc.view.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        }
    }
    
}
