//
//  AppDelegate.swift
//  PC7
//
//  Created by apple on 7/5/16.
//  Copyright © 2016 PassionConnect. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let layout = UICollectionViewFlowLayout()
        
        window?.rootViewController = UINavigationController(rootViewController: HomeController(collectionViewLayout: layout))
        
//        UINavigationBar.appearance().barTintColor = UIColor.rgb(94, green: 51, blue: 26)
        UINavigationBar.appearance().barTintColor = UIColor.orange
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        //remove black line
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage( UIImage(), for: .default )
        
        application.statusBarStyle = .lightContent
        
        let statusBarBackgroundView = UIView()
        statusBarBackgroundView.backgroundColor = UIColor.orange
        
        
        
        window?.addSubview(statusBarBackgroundView)
        window?.addConstraintsWithFormat("H:|[v0]|", views: statusBarBackgroundView)
        window?.addConstraintsWithFormat("V:|[v0(20)]", views: statusBarBackgroundView)
        
        FIRApp.configure()
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        //GIDSignIn.sharedInstance().delegate = self
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //return true
    }
    
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let checkFB = FBSDKApplicationDelegate.sharedInstance().application(
            app,
            open: url as URL!,
            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        let checkGoogle = GIDSignIn.sharedInstance().handle(url as URL!,
                                                             sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
                                                             annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return checkGoogle || checkFB
        
//        return FBSDKApplicationDelegate.sharedInstance().application(
//            app,
//            open: url as URL!,
//            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
//            annotation: options[UIApplicationOpenURLOptionsKey.annotation]
 //       )
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let checkFB = FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url as URL!,
            sourceApplication: sourceApplication,
            annotation: annotation)
        let checkGoogle = GIDSignIn.sharedInstance().handle(url as URL!,
                                                            sourceApplication: sourceApplication,
                                                            annotation: annotation)
        return checkGoogle || checkFB
    }
    
//    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        return FBSDKApplicationDelegate.sharedInstance().application(
//            application,
//            open: url as URL!,
//            sourceApplication: sourceApplication,
//            annotation: annotation)
//    }
//    func application(application: UIApplication,
//                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
//        return GIDSignIn.sharedInstance().handleURL(url as URL!,
//                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
//                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
//    }
//    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        return GIDSignIn.sharedInstance().handle(url as URL!,
//                                                    sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
//                                                    annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//
//    }
    
//    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
//        return GIDSignIn.sharedInstance().handleURL(url as URL!,
//                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String,
//                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
//        
//    }
    
    
//    func application(application: UIApplication,
//                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
//        var options: [String: AnyObject] = [UIApplicationOpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject,
//                                            UIApplicationOpenURLOptionsKey.annotation.rawValue: annotation!]
//        return GIDSignIn.sharedInstance().handle(url as URL!,
//                                                    sourceApplication: sourceApplication,
//                                                    annotation: annotation)
//    }
//    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        // ...
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
//    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//        // Override point for customization after application launch.
//        
//        // Initialize sign-in
//        var configureError: NSError?
//        GGLContext.sharedInstance().configureWithError(&configureError)
//        assert(configureError == nil, "Error configuring Google services: \(configureError)")
//        
//        GIDSignIn.sharedInstance().delegate = self
//        
//        return true
//    }
//    
//    func application(application: UIApplication,
//                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
//        return GIDSignIn.sharedInstance().handle(url as URL!,
//                                                    sourceApplication: sourceApplication,
//                                                    annotation: annotation)
//    }
//    
//    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
//                withError error: NSError!) {
//        if let error = error {
//            print(error.localizedDescription)
//            return
//        }
//        // ...
//    }
//    
//    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
//                withError error: NSError!) {
//        // Perform any operations when the user disconnects from app here.
//        // ...
//    }

 
    
//   private func application(application: UIApplication, openURL url: URL, sourceApplication: String?, annotation: AnyObject) -> Bool {
//    
//    
//       return FBSDKApplicationDelegate.sharedInstance().application(application, open : url as URL!, sourceApplication: sourceApplication, annotation: annotation)
//    
//   }
    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
//    }
    
//    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
//        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
//    }
//    
//    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
//        let shouldOpen :Bool = FBSDKApplicationDelegate.sharedInstance().application(
//            app,
//            open: url as URL!,
//            sourceApplication: options["UIApplicationOpenURLOptionsSourceApplicationKey"] as! String,
//            annotation: nil)
//        
//        
//        return shouldOpen
//        
//    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//    }
    
    
//    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]) -> Bool {
//        var configureError: Error?
//        GGLContext.sharedInstance().configureWithError(configureError as! NSErrorPointer)
//        assert(!(configureError != nil), "Error configuring Google services: %@", file: configureError as! StaticString)
//        GIDSignIn.sharedInstance().delegate = self
//        return true
//    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

