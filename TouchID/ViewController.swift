//
//  ViewController.swift
//  TouchID
//
//  Created by Akhil Tirumalasetty on 11/6/16.
//  Copyright © 2016 Akhil Tirumalasetty. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        authenticateUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func authenticateUser(){
        
        let authContext:LAContext = LAContext()
        let authReason = "Please Use Touch ID to sign In"
        var error:NSError?
        
        
        if authContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error){
        
            
            authContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason:authReason, reply: { (success, error)-> Void in
                
                if success{
                    
                    print("successfully login")
                    //want  to deal with UI code
                    dispatch_async(dispatch_get_main_queue(),{()-> Void in
                        
                    
                    })
                }else{
                    if let error = error{
                       
                        dispatch_async(dispatch_get_main_queue(),{()-> Void in
                            
                           self.reportTouchIdError(error)
                        })
                        
                    }
                    
                }
                
                })
            
                }else{
            
                }
    }
    
    func reportTouchIdError(error:NSError){
        
        switch error.code{
            
        case LAError.AuthenticationFailed.rawValue:
            print("Aunthentication Failed")
            
        case LAError.PasscodeNotSet.rawValue:
            print("Password Not Set")
            
        case LAError.SystemCancel.rawValue:
            print("Aunthentication Was Cancelled by system")
            
        case LAError.UserCancel.rawValue:
            print("UserCancel auth")
            
        case LAError.TouchIDNotEnrolled.rawValue:
            print("User has not enrolled any finger with  touch id ")
         
        case LAError.TouchIDNotAvailable.rawValue:
            print("Touch Id not available")
            
        case LAError.UserFallback.rawValue:
            print("User Tapped enter password")
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.showPasswordAlert()
            })
         
        default:
            print(error.localizedDescription)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.showPasswordAlert()
            })
        }
    }
    
    // MARK: Password Alert
    
    func showPasswordAlert()
    {
        let alertController = UIAlertController(title: "Touch ID Password", message: "Please enter your password.", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Cancel) { (action) -> Void in
            
            if let textField = alertController.textFields?.first as UITextField?
            {
                if textField.text == "akhil"
                {
                    print("Authentication successful! :) ")
                }
                else
                {
                    self.showPasswordAlert()
                }
            }
        }
        alertController.addAction(defaultAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            
            textField.placeholder = "Password"
            textField.secureTextEntry = true
            
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

