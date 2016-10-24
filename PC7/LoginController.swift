//
//  LoginController.swift
//  PC7
//
//  Created by apple on 8/7/16.
//  Copyright © 2016 PassionConnect. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit


let ref = "https://passionconnectios.firebaseapp.com"
let facebookLogin = FBSDKLoginManager()
let facebookPermissions = ["public_profile", "email", "user_friends"]

class LoginController: UIViewController, FBSDKLoginButtonDelegate {
    
//    let loginButton: FBSDKLoginButton = {
//        let button = FBSDKLoginButton()
//        button.readPermissions = ["email"]
//        return button
//    }()
//    
    var loginButton = FBSDKLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let loginButton = FBSDKLoginButton()
        
        self.loginButton.center = self.view.center
        
        self.loginButton.readPermissions = ["public_profile", "email"]
        self.loginButton.delegate = self
        view.addSubview(loginButton)
        //loginButton.center = view.center
        
//        if (FBSDKAccessToken.current() != nil)
//        {
//            print("login")
//        }
//        else {
//            
//           print("not login")
//        }
    }
    
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if ((error) != nil) {
            // Process error
        }
//        else if result.isCancelled {
//            // Handle cancellations
//        }
        else {
            // Navigate to other view
            print ("facebook login complete")
            fetchProfile()
            //self.navigationController?.popToRootViewController(animated: true)
        }
        //fetchProfile()
        print("logged in")
    }
    
    func fetchProfile() {
        //let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        //FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            
            let parameters = ["fields": "id, email, first_name, last_name, picture.type(large)"]
            FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { (connection, user, requestError) -> Void in
                
                if requestError != nil {
                    print(requestError)
                    return
                }
                if let dataDict = user as? [String: AnyObject] {
                    var email = dataDict["email"] as? String
                    let firstName = dataDict["first_name"] as? String
                    let lastName = dataDict["last_name"] as? String
                    let id = dataDict["id"] as? String
                    print(email)
                    print(firstName)
                    print(lastName)
                    var pictureUrl = ""
                    
                    if let picture = dataDict["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String {
                        pictureUrl = url
                    }
                    
                    // self.nameLabel.text = "\(firstName!) \(lastName!)"
                    
                    
                    
                    
                    
                    let imgPath: String = pictureUrl
                    
                    // http://pcapi.azurewebsites.net/api/Validate?UserId={"email":"testmialo@gmail.com","first_name":"Test Test","gender":null,"id":"102758773762041126263","ImagePath":null,"last_name":"Test Test","name":"Test Test"}
                    
                    let parameters = ["email": email!, "first_name": firstName!, "gender": "", "id": id!, "ImagePath": imgPath, "last_name": firstName!, "name": firstName!] as Dictionary<String, String>
                    
                    
                    var jsonData: Data
                    var jsonString: String = ""
                    let url = "http://pcapi.azurewebsites.net/api/Validate?UserId="
                    
                    do{
                        jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                        print(jsonData)
                        jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String
                        print(jsonString)
                        
                    } catch _ {
                        print ("UH OOO")
                        //return nil
                    }
                    
                    let escapedString = jsonString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
                    let s1 = (url + escapedString!)
                    
                    let s2 = URL (string: s1)
                    
                    let request = NSMutableURLRequest(url: s2!)
                    request.httpMethod = "GET"
                    //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    //request.addValue("application/json", forHTTPHeaderField: "Accept")
                    print(s2)
                    
                    
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                        
                        if error != nil {
                            print(error)
                            return
                        }
                        
                        print(data)
                        
                        let responseStr:NSString = NSString(data:data!, encoding:String.Encoding.utf8.rawValue)!
                        print(responseStr)
                        //let userid = Int(responseStr)
                        
                        UserDefaults.standard.set(true,forKey:"isUserLoggedIn")
                        UserDefaults.standard.set(responseStr, forKey: "UserId")
                        
                        var savedValue = UserDefaults.standard.string(forKey: "UserId")
                        print(savedValue)
                        
                        //            let array = NSUserDefaults.standardUserDefaults().stringForKey("UserId") as? [String] ?? [String]()
                        //            print(array)
                        //
                        //            if array.isEmpty {
                        //                print("userid not logged in")
                        //            }
                        //            else
                        //            {
                        //                print("user is logged in")
                        //            }
                        
                        
                        
                        self.dismiss(animated: true, completion:nil)
                        
                        DispatchQueue.main.async{
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        
                        } .resume()
                }
            })
        }
        
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
