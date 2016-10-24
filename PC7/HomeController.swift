//
//  ViewController.swift
//  PC7
//
//  Created by apple on 7/5/16.
//  Copyright © 2016 PassionConnect. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var videos: [Video]?
    //var loginstatus: Bool
    var p = [Int]()
    //var myWebView: UIWebView
    fileprivate let reuseIdentifier1 = "Cell"
    fileprivate var numberOfItemsPerSection = 8
    
    
    func fetchVideos() {
        
        if let myArray = UserDefaults.standard.object(forKey: "p") as? [Int] {
            self.p = myArray
        }
        
         let updatePassion = UserDefaults.standard.object(forKey: "updatepassion") as! Bool
            if updatePassion {
                UserDefaults.standard.set(false, forKey: "updatepassion")
            }
        
        
        //self.p = myArray
        if p.count == 0 {
            p.append(4)
            p.append(5)
            p.append(6)
            p.append(7)
            p.append(8)
        }
        
        let parameters = ["ArticleId": 0 as AnyObject, "PassionID": p as AnyObject, "SeeArticlesFrom": 0 as AnyObject, "Sort": 0 as AnyObject, "Type":"" as AnyObject, "UpdatePassions": updatePassion  as AnyObject, "UpdatedBy": "testmialo@gmail.com" as AnyObject, "UserId": "4386" as AnyObject, "landingParameter": 0 as AnyObject] as Dictionary<String, AnyObject>
        
        
        var jsonData: Data
        var jsonString: String = ""
        let url = "http://pcapi.azurewebsites.net/api/IOSUpdate?selectedPassions="
        
        do{
            jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String
            
        } catch _ {
            print ("UH OOO")
            //return nil
        }
        
        let escapedString = jsonString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
        let s1 = (url + escapedString!)
        
        let s2 = URL (string: s1)
        
        let request = NSMutableURLRequest(url: s2!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                print(error)
                return
            }
            
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                if self.numberOfItemsPerSection == 8 {
                self.videos = [Video]()
                }
                
                for dictionary in json as! [[String: AnyObject]] {
                    
                    let video = Video()
                    
                    video.title = dictionary["Title"] as? String
                    let img = dictionary["URL"] as? String
                    video.thumbnailImageName = "http://passionconnect.in" + img!
                    video.relatedurl = dictionary["ReleatedURL"] as? String
                    video.desc = dictionary["Description"] as? String
                    video.source = dictionary["Source"] as? String
                    video.views = dictionary["Views"] as? Int
                    video.content = dictionary["Content"] as? String
                    video.liked = dictionary["Liked"] as? String
                    video.itemid = dictionary["ItemId"] as? Int
                    video.category = dictionary["CategoryName"] as? String
                    
                    let channelDictionary = dictionary["user"] as! [String: AnyObject]
                    
                    let channel = Channel()
                    channel.name = channelDictionary["UserName"] as? String
                    let img1 = channelDictionary["UserImage"] as? String
                    channel.profileImageName = "http://passionconnect.in" + img1!
                    
                    video.channel = channel
                    
                    self.videos?.append(video)
                }
                
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                })
                
            }
                
            catch let jsonError {
                print(jsonError)
            }
            
            
            } .resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.removeObject(forKey: "UserId")
        UserDefaults.standard.removeObject(forKey: "TestResult")
        UserDefaults.standard.set("1182", forKey: "UserId")
        UserDefaults.standard.set(false, forKey: "updatepassion")
        let savedValue = UserDefaults.standard.string(forKey: "UserId")
        print(savedValue)
        
        
        if savedValue == nil {
            let controller = GoogleController()
            //let controller = LoginController()
            navigationController?.pushViewController(controller, animated: true)
        }
        
        
        
        print("123")
        fetchVideos()
        
        navigationItem.title = "HOME"
        
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "PASSIONCONNECT"
        titleLabel.textColor = UIColor.white
        //titleLabel.font = UIFont(descriptor: <#T##UIFontDescriptor#>, size: <#T##CGFloat#>)
        titleLabel.textAlignment = NSTextAlignment.center
        navigationItem.titleView = titleLabel
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        //setupMenuBar()
        setupNavBarButtons()
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeController.didTapCollectionView(_:)))
        tapGesture.numberOfTapsRequired = 1  // add double tap
        self.collectionView!.addGestureRecognizer(tapGesture)
        
    }
    
    func didTapCollectionView(_ gesture: UITapGestureRecognizer) {
        let pointInCollectionView: CGPoint = gesture.location(in: self.collectionView)
        let selectedIndexPath: IndexPath = self.collectionView!.indexPathForItem(at: pointInCollectionView)!
        let selectedCell: UICollectionViewCell = self.collectionView!.cellForItem(at: selectedIndexPath)!
        
        // Rest code
        print("tap")
        
        print(pointInCollectionView)
        print(selectedIndexPath)
        print(selectedCell)
        let index = CGFloat((selectedIndexPath as NSIndexPath).item) + 1
       
        //let titleImageHeight: CGFloat = index * 250
        //let titleImageLessConstraing: CGFloat = titleImageHeight - 250
        let h = view.frame.width
        let height = ((h - 16 - 16) * (9/16)) + 20 + 30 + 16 + 88 + 60 + 60
        var y = pointInCollectionView.y
        
        
        let indexClick = (selectedIndexPath as NSIndexPath).item
        
        y = y - (CGFloat(height) * CGFloat(indexClick))
        
//        while indexClick > 7 {
//            indexClick = indexClick - 8
//        }
        
       
        if let article = videos?[indexClick] {
            
            if y >= 245 && y<=284 {
                print ("title")
                if article.relatedurl != "" {
                    externalArticle(article)
                }
                else {
                    showArticle(article)
                }

            }
            
            else if y >= 430 && y <= 464 {
                if pointInCollectionView.x >= 74 && pointInCollectionView.x <= 207 {
                    print ("source")
                    if article.relatedurl != "" {
                        externalArticle(article)
                    }
                    else {
                        showArticle(article)
                    }
                }
                else if pointInCollectionView.x >= 208 && pointInCollectionView.x <= 223 {
                    print ("share")
                }
                else if pointInCollectionView.x >= 306 && pointInCollectionView.x <= 326 {
                    print ("like")
                   // like(article)
                    
                }
            }
            
            //showArticle(article)
//            if pointInCollectionView.y < titleImageHeight && pointInCollectionView.y > titleImageLessConstraing {
                //print(article.relatedurl)
                if article.relatedurl != "" {
                    //CouponPassionTest(article)
                    //PassionTest(article)
                    //UpdatePassion(article)
                    //login(article)
                }
                else {
                    //CouponPassionTest(article)
                    //PassionTest(article)
                    //UpdatePassion(article)
                    //login(article)
                }
//
//            }
            
        }
        
        
        print("tap")
    }
    
    func setupNavBarButtons() {
        //let searchImage = UIImage(named: "side-menu")?.imageWithRenderingMode(.AlwaysOriginal)
        //let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .Plain, target: self, action: #selector(handleSearch))
        let moreButton = UIBarButtonItem(image: UIImage(named: "side-menu")?.withRenderingMode(.alwaysOriginal ), style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [moreButton]
    }
    
    let settingsLauncher = SettingsLauncher()
    
    func handleMore(){
        
        let controller = SelectPassion()
        self.navigationController?.pushViewController(controller, animated: true)
        
//        settingsLauncher.homeController = self
//        settingsLauncher.showSettings()
        
    }
    
    func showControllerForSettings () {
        //self.url = NSURL(string: "adaf")
        let savedValue = UserDefaults.standard.string(forKey: "Refresh")
        fetchVideos()
        
        self.collectionView?.reloadData()
        //self.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition: .Top, animated: true)
        //self.collectionView?.scrollsToTop = true
    }
    
    func handleSearch(){
        print(123)
    }

//    let menuBar: MenuBar = {
//        let mb = MenuBar()
//        return mb
//    }()
//    
//    private func setupMenuBar() {
//        view.addSubview(menuBar)
//        view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
//        view.addConstraintsWithFormat("V:|[v0(50)]", views: menuBar)
//    } 
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return videos?.count ?? 0
        return numberOfItemsPerSection
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
        
        print((indexPath as NSIndexPath).item)
        
        var index = (indexPath as NSIndexPath).item
        while index > 7 {
            index = index - 8
        }
        print(index)
        if (indexPath as NSIndexPath).item < videos?.count {
        cell.video = videos?[(indexPath as NSIndexPath).item]
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = view.frame.width 
        let height = ((h - 16 - 16) * (9/16)) + 20 + 30
        return CGSize(width: view.frame.width, height: height + 16 + 88 + 60 + 60)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    
    func showArticle(_ article: Video) {
        
        //let layout = ArticleDetailController()
        
        let articleDetailController = ArticleDetailController()
        articleDetailController.article = article
        articleDetailController.itemid = String(article.itemid!)
        navigationController?.pushViewController(articleDetailController, animated: true)
        
    }
    
    func showArticle1(_ article: Video) {
        let controller = ArticleView()
        controller.article = article
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func login(_ article: Video) {
        let controller = GoogleController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func login() {
        let controller = LoginController()
        navigationController?.pushViewController(controller, animated: true)
    }
    func externalArticle(_ article: Video) {
        let controller = WebView()
        controller.url = article
        navigationController?.pushViewController(controller, animated: true)
    }
    func UpdatePassion(_ article: Video) {
        let controller = SelectPassion()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func PassionTest(_ article: Video) {
        let controller = QuestionController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func CouponPassionTest(_ article: Video) {
        let controller = TakePassionTest()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let refreshValue = UserDefaults.standard.string(forKey: "Refresh")
        print(refreshValue)
        
        
        if refreshValue == "1" {
            UserDefaults.standard.set("0", forKey: "Refresh")
            
        }
        else {
            fetchVideos()
        }
        
        DispatchQueue.main.async(execute: {
            self.collectionView!.reloadData()
            })
       
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("in scroll")
        let h = view.frame.width - 16 - 16
        let height = (((h) * (9/16)) + 16 + 88 + 60 + 16)
         //print(height)
        let scrollCall = (height * (CGFloat)(numberOfItemsPerSection - 4))

        
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        //print(bottomEdge)
        //print(scrollView.contentSize.height)
        if (bottomEdge >= scrollCall) {
            print("in load infinite scroll")
            numberOfItemsPerSection += 8
            fetchVideos()
            //print("videos.count="+(videos?.count.description)!)
            self.collectionView!.reloadData()
            
        }
    }
    
   
  
  
}






