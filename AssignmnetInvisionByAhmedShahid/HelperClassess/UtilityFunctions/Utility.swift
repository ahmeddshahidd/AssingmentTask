//
//  Utility.swift
//  AssignmnetInvisionByAhmedShahid
//
//  Created by Ahmed Shahid on 09/09/2019.
//  Copyright © 2019 Ahmed Shahid. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView


class Utility: NSObject
{
    static let shared = Utility()
    fileprivate override init() {}
    
    
    func showLabelIfNoData(withtext text: String, controller: UIViewController, tableview: UITableView) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: controller.view.bounds.size.width, height: controller.view.bounds.size.height))
        messageLabel.text = text
        messageLabel.textColor = UIColor.white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Palatino-Italic", size: 20) ?? UIFont()
        messageLabel.sizeToFit()
        tableview.backgroundView = messageLabel;
    }
}

// MARK:- INDICATOR
extension Utility {
    func showLoader() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let size = CGSize(width: 50, height: 50)
        let bgColor = UIColor.clear//UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let activityData = ActivityData(size: size, message: "", messageFont: UIFont.systemFont(ofSize: 12), type: .ballClipRotate, color: UIColor.lightGray , padding: 0, displayTimeThreshold: 0, minimumDisplayTime: 1, backgroundColor: bgColor, textColor: UIColor.black)
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    func hideLoader() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
}

// MARK: - UIALERTCONTROLLER
extension Utility {
    func showAlert(message:String,title:String,controller:UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        controller.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithOptionalController(message:String,title:String,controller:UIViewController?) -> UIViewController?{
        if(controller == nil)
        {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            return alertController
        }
        else
        {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            controller!.present(alertController, animated: true, completion: nil)
            
            return nil
        }
    }
    
    
    
    func showAlert(message: String, title: String, controller: UIViewController, usingCompletionHandler handler:@escaping (() -> Swift.Void))
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            
            (action) in
            
            handler()
        }
        ))
        controller.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(message:String,title:String,controller:UIViewController, completionHandler: @escaping (UIAlertAction?, UIAlertAction?) -> Void){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //       alertController.view.tintColor = Constants.THEME_ORANGE_COLOR
        alertController.addAction(UIAlertAction(title: "YES", style: .default){ (alertActionYES) in
            completionHandler(alertActionYES, nil)
        })
        
        alertController.addAction(UIAlertAction(title: "NO", style: .cancel){ (alertActionNO) in
            completionHandler(nil, alertActionNO)
        })
        
        controller.present(alertController, animated: true, completion: nil)
        
    }
    
    func showAlert(message:String,title:String,controller:UIViewController, firstButtonText: String, secondButtonText: String, completionHandler: @escaping (UIAlertAction?, UIAlertAction?) -> Void){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //       alertController.view.tintColor = Constants.THEME_ORANGE_COLOR
        alertController.addAction(UIAlertAction(title: firstButtonText, style: .default){ (alertActionYES) in
            completionHandler(alertActionYES, nil)
        })
        
        alertController.addAction(UIAlertAction(title: secondButtonText, style: .cancel){ (alertActionNO) in
            completionHandler(nil, alertActionNO)
        })
        
        controller.present(alertController, animated: true, completion: nil)
        
    }
    
    func showAlert(message:String,title:String){
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            topController.present(alertController, animated: true, completion: nil)
            
        }
    }
}
