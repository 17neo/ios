//
//  GoogleLogin.swift
//  PC7
//
//  Created by apple on 8/9/16.
//  Copyright © 2016 PassionConnect. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit

class GoogleController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, FBSDKLoginButtonDelegate {
    
    private let dataUrl = "https://passionconnectios.firebaseapp.com"
    
//    let loginButton: FBSDKLoginButton = {
//        let button = FBSDKLoginButton()
//        button.readPermissions = ["email"]
//        button.imageView?.image = UIImage(named: "facebook")
//        return button
//    }()
    
    
    //var loginButton = FBSDKLoginButton()
    
    let loginButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        //button.backgroundColor = .greenColor()
        //button.setTitle("Login with g+", forState: .Normal)
        button.setImage(UIImage(named: "facebook"), for: UIControlState())
        return button
    }()
    
    let googleButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        //button.backgroundColor = .greenColor()
        //button.setTitle("Login with g+", forState: .Normal)
        button.setImage(UIImage(named: "google"), for: UIControlState())
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome To The World Of Passion"
        label.font = UIFont(name: "SF-UI-Display-Ultralight", size: 50)
        label.font = UIFont.systemFont(ofSize: 22)
        //label.numberOfLines = 2
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login.png")!)
        assignbackground()
        var error: NSError?
        //GGLContext.sharedInstance().configureWithError(&error)
        
        if error != nil {
            print(error)
            return
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        //self.loginButton.center = self.view.center
        //self.titleLabel.center = self.view.center
        
        //self.loginButton.readPermissions = ["public_profile", "email"]
        //self.loginButton.delegate = self
        
        let signInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        
        loginButton.addTarget(self, action: #selector(handleFacebook), for: .touchUpInside)
        
        //signInButton.backgroundColor = UIColor.orangeColor()
        signInButton.colorScheme = GIDSignInButtonColorScheme.dark
        
        //loginButton.setBackgroundImage(UIImage(named: "like1"), forState: UIControlState.Normal)
        //loginButton.setImage(nil, forState: UIControlState.Normal)
        //loginButton.setTitle("Hi", forState: UIControlState.Normal)
        googleButton.addTarget(self, action: #selector(GoogleController.googleSignInClicked(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(googleButton)
        view.addSubview(loginButton)
        view.addSubview(titleLabel)
        
        self.view.addConstraintsWithFormat("H:|-55-[v0]", views: loginButton)
        self.view.addConstraintsWithFormat("H:|-55-[v0]", views: googleButton)
        self.view.addConstraintsWithFormat("H:|-16-[v0]-16-|", views: titleLabel)
        self.view.addConstraintsWithFormat("V:|-150-[v0(70)]-275-[v1]-25-[v2]", views: titleLabel, loginButton, googleButton)
        self.navigationItem.hidesBackButton = true
        //self.navigationController!.navigationBar.leftItem!.title = "Back"
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    
    func handleFacebook () {
        var fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logIn(withReadPermissions: ["email"], handler: { (result, error) -> Void in
            if (error == nil){
                var fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil
                {
                    self.fetchProfile()
                    //fbLoginManager.logOut()
                }
            }
        })
    }
   
    func googleSignInClicked(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error)
        }
        
        print(user.profile.email)
        print(user.profile.imageURL(withDimension: 400))
        print(user.profile.name)
        
        let imgPath: String = user.profile.imageURL(withDimension: 400).path
        
       // http://pcapi.azurewebsites.net/api/Validate?UserId={"email":"testmialo@gmail.com","first_name":"Test Test","gender":null,"id":"102758773762041126263","ImagePath":null,"last_name":"Test Test","name":"Test Test"}
        
        let parameters = ["email": user.profile.email, "first_name": user.profile.name, "gender": "", "id": user.userID, "ImagePath": imgPath, "last_name": user.profile.name, "name": user.profile.name] as Dictionary<String, String>
        
        
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
                //self.navigationController?.popToRootViewController(animated: true)
                let controller = SelectPassion()
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
            } .resume()
        
        
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
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            
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
                //self.navigationController?.popToRootViewController(animated: true)
                let controller = SelectPassion()
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
            } .resume()
            }
        })
    }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    func assignbackground(){
        let background = UIImage(named: "login-bg")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
   
}
