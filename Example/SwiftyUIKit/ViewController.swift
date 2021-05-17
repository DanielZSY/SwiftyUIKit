//
//  ViewController.swift
//  SwiftyUIKit
//
//  Created by DanielZSY on 05/14/2021.
//  Copyright (c) 2021 DanielZSY. All rights reserved.
//

import UIKit
import BFKit
import SwiftyUIKit

class ViewController: UIViewController {
    
    private lazy var btnAlertCustom: UIButton = {
        let item = UIButton.init(frame: CGRect.init(x: 20.scale, y: 100, width: 150.scale, height: 45))
        item.adjustsImageWhenHighlighted = false
        item.titleLabel?.fontSize = 14
        item.setTitle("AlertCustom", for: .normal)
        item.setTitleColor("#7037E9".color, for: .normal)
        item.border(color: "#7037E9".color, radius: 10, width: 1)
        item.addTarget(self, action: #selector(self.btnAlertClick), for: .touchUpInside)
        return item
    }()
    private lazy var btnSheetCustom: UIButton = {
        let item = UIButton.init(frame: CGRect.init(x: 200.scale, y: 100, width: 150.scale, height: 45))
        item.adjustsImageWhenHighlighted = false
        item.titleLabel?.fontSize = 14
        item.setTitle("SheetCustom", for: .normal)
        item.setTitleColor("#7037E9".color, for: .normal)
        item.border(color: "#7037E9".color, radius: 10, width: 1)
        item.addTarget(self, action: #selector(self.btnSheetCustomClick), for: .touchUpInside)
        return item
    }()
    private lazy var btnAlertCustomNoTitle: UIButton = {
        let item = UIButton.init(frame: CGRect.init(x: 20.scale, y: 150, width: 150.scale, height: 45))
        item.adjustsImageWhenHighlighted = false
        item.titleLabel?.fontSize = 14
        item.setTitle("AlertCustom NoTitle", for: .normal)
        item.setTitleColor("#7037E9".color, for: .normal)
        item.border(color: "#7037E9".color, radius: 10, width: 1)
        item.addTarget(self, action: #selector(self.btnAlertCustomNoTitleClick), for: .touchUpInside)
        return item
    }()
    private lazy var btnSheetCustomNoTitle: UIButton = {
        let item = UIButton.init(frame: CGRect.init(x: 200.scale, y: 150, width: 150.scale, height: 45))
        item.adjustsImageWhenHighlighted = false
        item.titleLabel?.fontSize = 14
        item.setTitle("SheetCustom NoTitle", for: .normal)
        item.setTitleColor("#7037E9".color, for: .normal)
        item.border(color: "#7037E9".color, radius: 10, width: 1)
        item.addTarget(self, action: #selector(self.btnSheetCustomNoTitleClick), for: .touchUpInside)
        return item
    }()
    private lazy var btnHud: UIButton = {
        let item = UIButton.init(frame: CGRect.init(20.scale, 220, 150.scale, 45))
        item.adjustsImageWhenHighlighted = false
        item.titleLabel?.fontSize = 14
        item.setTitle("Progress Hud", for: .normal)
        item.setTitleColor("#7037E9".color, for: .normal)
        item.border(color: "#7037E9".color, radius: 10, width: 1)
        item.addTarget(self, action: #selector(self.btnProgressHudClick), for: .touchUpInside)
        return item
    }()
    private lazy var textField1: ZTextField = {
        let item = ZTextField.init(frame: CGRect.init(20.scale, 280, 300.scale, 45))
        item.placeholder = "Test Content"
        item.addLeftAndRightSpace(10, item.height)
        item.tag = 1
        item.isPre = false
        item.isNext = true
        return item
    }()
    private lazy var textField2: ZTextField = {
        let item = ZTextField.init(frame: CGRect.init(20.scale, textField1.y + textField1.height + 10, 300.scale, 45))
        item.placeholder = "Test Content"
        item.addLeftAndRightSpace(10, item.height)
        item.tag = 2
        item.isPre = true
        item.isNext = true
        return item
    }()
    private lazy var textField3: ZTextView = {
        let item = ZTextView.init(frame: CGRect.init(20.scale, textField2.y + textField2.height + 10, 300.scale, 100))
        item.placeholder = "Test Content"
        item.tag = 3
        item.isPre = true
        item.isNext = false
        return item
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BFLog.active = true
        self.view.backgroundColor = "#100D13".color
        self.view.addSubview(btnAlertCustom)
        self.view.addSubview(btnSheetCustom)
        self.view.addSubview(btnAlertCustomNoTitle)
        self.view.addSubview(btnSheetCustomNoTitle)
        self.view.addSubview(btnHud)
        self.view.addSubview(textField1)
        self.view.addSubview(textField2)
        self.view.addSubview(textField3)
        
        textField1.onToolButtonClick = { row in
            switch row {
            case 2: self.textField2.becomeFirstResponder()
            default: break
            }
        }
        textField2.onToolButtonClick = { row in
            switch row {
            case 1: self.textField1.becomeFirstResponder()
            case 2: self.textField3.becomeFirstResponder()
            default: break
            }
        }
        textField3.onToolButtonClick = { row in
            switch row {
            case 1: self.textField2.becomeFirstResponder()
            default: break
            }
        }
    }
    @objc private func btnAlertClick() {
        ZAlertView.showAlertView(vc: self, title: "title", message: "Do you want to report this user?", button: "Continue", cancel: "Cancel", callBack: { row in
            
            BFLog.debug("row: \(row)")
        })
    }
    @objc private func btnSheetCustomClick() {
        let itemVC = ZAlertSheetViewController.init(title: "title", message: "message", buttons: ["Photo","Album","Camera"], cancel: "Cancel", callBack: { row in
            BFLog.debug("row: \(row)")
        })
        self.present(itemVC, animated: false, completion: nil)
    }
    @objc private func btnAlertCustomNoTitleClick() {
        let itemVC = ZAlertViewController.init(title: nil, message: "Do you want to report this user", button: "Continue", cancel: "Cancel", callBack: { row in
            BFLog.debug("row: \(row)")
        })
        self.present(itemVC, animated: true, completion: nil)
    }
    @objc private func btnSheetCustomNoTitleClick() {
        let itemVC = ZAlertSheetViewController.init(title: nil, message: nil, buttons: ["Photo","Album","Camera"], cancel: "Cancel", callBack: { row in
            BFLog.debug("row: \(row)")
        })
        self.present(itemVC, animated: false, completion: nil)
    }
    @objc private func btnProgressHudClick() {
        ZProgressHUD.show(vc: self)
        
        DispatchQueue.DispatchAfter(after: 2, handler: {
            ZProgressHUD.dismiss()
            ZProgressHUD.showMessage(vc: self, text: "Show Hud End")
        })
    }
}

