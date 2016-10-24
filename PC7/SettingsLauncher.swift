//
//  SettingsLauncher.swift
//  PC7
//
//  Created by apple on 7/31/16.
//  Copyright © 2016 PassionConnect. All rights reserved.
//

import UIKit

class Setting: NSObject {
    let name: String
    let imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

class SettingsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    
    var settings: [Passions]?
    
    
    func fetchPassions() {
        
        //let parameters = ["ItemId": "7255", "UserId": "4386"] as Dictionary<String, AnyObject>
        
        
        
        let url = "http://pcapi.azurewebsites.net/api/article?UserId=4386"
        
        //let url = "http://pcapi.azurewebsites.net/api/Questions"
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                
                
                
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                self.settings = [Passions]()
                
                for dictionary in json as! [[String: AnyObject]] {
                    
                    let p = Passions()
                    
                    p.title = dictionary["Title"] as? String
                    //p.id = dictionary["ID"] as? String
                    p.id = "plus"
                    
                    self.settings?.append(p)
                    
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.collectionView.reloadData()
                })
                
            } catch let err {
                print(err)
            }
            
            
        }).resume()
    }
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let profileView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "mark")
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    

    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Shubham deva"
        //label.numberOfLines = 1
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "shubham.neo17@gmail.com"
        //label.numberOfLines = 1
        return label
    }()
    
    let cellId = "CellId"
    let cellId1 = "CellId1"
    
    let cellHeight: CGFloat = 50
    
//    let settings: [Setting] = {
//        
//        return [Setting(name: "Travel", imageName: "like1"),Setting(name: "Food", imageName: "like1"), Setting(name: "Fitness", imageName: "like1"), Setting(name: "Mythology", imageName: "like1"), Setting(name: "Movies", imageName: "like1"), Setting(name: "Profile", imageName: "like1")]
//    }()
    
    
    var homeController: HomeController?
    
    func setupProfileView() {
        profileView.addSubview(userProfileImageView)
        profileView.addSubview(nameLabel)
        profileView.addSubview(emailLabel)
        
        
       // profileView.addConstraintsWithFormat("H:|-8-[v0(44)]-8-[v1]|", views: userProfileImageView, nameLabel)
        
        
        //profileView.addConstraintsWithFormat("V:|-10-[v0(44)]", views: userProfileImageView)
        //profileView.addConstraintsWithFormat("V:|-54-[v0(14)]", views: nameLabel)
        
    }
    
    
    func showSettings(){
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            setupProfileView()
            window.addSubview(blackView)
            window.addSubview(profileView)
            window.addSubview(collectionView)
            
            
           
            
            
            //window.addSubview(userProfileImageView)
            //window.addSubview(nameLabel)
            //window.addSubview(emailLabel)
            
            let height: CGFloat = CGFloat(settings!.count) * cellHeight
            //let y = window.frame.height - height
            //collectionView.frame = CGRectMake(<#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
            collectionView.frame = CGRect(x: -window.frame.width, y: 150, width: window.frame.width - 50, height: 500)
            
            collectionView.isScrollEnabled = true
            profileView.frame = CGRect(x: -window.frame.width, y: 0, width: window.frame.width - 50, height: 150)
            //userProfileImageView.frame = CGRect(x: -window.frame.width, y: 0, width: 44, height: 44)
            //nameLabel.frame = CGRect(x: -window.frame.width, y: 60, width: window.frame.width - 50, height: 20)
            //emailLabel.frame = CGRect(x: -window.frame.width, y: 85, width: window.frame.width - 50, height: 20)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRect(x: 0, y: 150, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
                self.profileView.frame = CGRect(x: 0, y: 0, width: self.profileView.frame.width, height: self.profileView.frame.height)
                
                self.userProfileImageView.frame = CGRect(x: 0, y: 20, width: 44, height: 44)
                
                //self.userProfileImageView.frame = CGRect(x: 0, y: 20, width: 5, height: 5)
                
                //self.nameLabel.frame = CGRect(x: 50, y: 200, width: self.nameLabel.frame.width, height: self.nameLabel.frame.height)
                
               // self.emailLabel.frame = CGRect(x: 100, y: 300, width: self.emailLabel.frame.width, height: self.emailLabel.frame.height)
                
                }, completion: nil)
            
        }
        
    }
    
    func handleDismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: -window.frame.width, y: 150, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
                self.profileView.frame = CGRect(x: -window.frame.height, y: 0, width: self.profileView.frame.width, height: self.profileView.frame.height)
                
                //self.userProfileImageView.frame = CGRect(x: -window.frame.height, y: 0, width: self.userProfileImageView.frame.width, height: self.userProfileImageView.frame.height)
                
                 //self.nameLabel.frame = CGRect(x: -window.frame.height, y: 60, width: self.nameLabel.frame.width, height: self.nameLabel.frame.height)
                
                 //self.emailLabel.frame = CGRect(x: -window.frame.height, y: 85, width: self.emailLabel.frame.width, height: self.emailLabel.frame.height)
                
            }
        }) 
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        
        let setting = settings![(indexPath as NSIndexPath).item]
        cell.setting = setting
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let setting = settings[indexPath.item]
        
//        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: {
//            
//            self.blackView.alpha = 0
//            
//            if let window = UIApplication.sharedApplication().keyWindow {
//                self.collectionView.frame = CGRectMake(-window.frame.width, 0, self.collectionView.frame.width, self.collectionView.frame.height)
//                self.profileView.frame = CGRectMake(-window.frame.width, 0, self.profileView.frame.width, self.profileView.frame.height)
//                self.userProfileImageView.frame = CGRectMake(-window.frame.width, 10, self.userProfileImageView.frame.width, self.userProfileImageView.frame.height)
//            }
//
//            
//        }) { (completed: Bool) in
//            
//            self.homeController?.showControllerForSettings()
//            
//        }
        
        
    }
    
    
    override init() {
        super.init()
        fetchPassions()
        collectionView.isScrollEnabled = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        //collectionView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellWithReuseIdentifier: <#T##String#>)
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
        //profileView.register(LeftSlideHeader.self, forCellWithReuseIdentifier: cellId1)
        collectionView.register(LeftSlideHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader , withReuseIdentifier: "headerCell")
    }
    
}
