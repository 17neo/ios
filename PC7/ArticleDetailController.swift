//
//  articleDetailController.swift
//  PC7
//
//  Created by apple on 8/3/16.
//  Copyright © 2016 PassionConnect. All rights reserved.
//

import UIKit

//fileprivate var contentHeight: CGFloat = 0
//
//fileprivate var cHeight: CGFloat = 0
//
//fileprivate var counter: Int = 0
//fileprivate var height = 0.00

class ArticleDetailController: UITableViewController, UIWebViewDelegate {
    
    var itemid = "0"
    var coverPic = ""
    var height = 0.00
    
//    var article: Video? {
//        didSet {
//            
//            //let parameters = ["ItemId": "7255" as AnyObject, "UserId": "4386" as AnyObject] as Dictionary<String, AnyObject>
//            let parameters = ["ItemId": itemid as AnyObject, "UserId": "4386" as AnyObject] as Dictionary<String, AnyObject>
//            
//            var jsonData: Data
//            var jsonString: String = ""
//            //var content: String = ""
//            let url = "http://pcapi.azurewebsites.net/api/LandingContainer?input="
//            
//            do{
//                jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
//                jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String
//                
//            } catch _ {
//                print ("UH OOO")
//                //return nil
//            }
//            
//            let escapedString = jsonString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
//            let s1 = (url + escapedString!)
//            
//                
//                URLSession.shared.dataTask(with: URL(string: s1)!, completionHandler: { (data, response, error) -> Void in
//                    
//                    if error != nil {
//                        print(error)
//                        return
//                    }
//                    
//                    do {
//                        
//                        
//                        
//                        if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
//                            
//                            let appDetail = Video()
//                            
//                            if let con = (convertedJsonIntoDict["Content"] as? String) {
//                                appDetail.content = con
//                            }
//
//                            
//                            //self.article!.content = (convertedJsonIntoDict["Content"] as? String)!
//                            
//                            //appDetail.setValuesForKeysWithDictionary(json as! [String: AnyObject])
//                            
//                            self.article?.content = appDetail.content
//                            
//                        }
//                        
//                        DispatchQueue.main.async(execute: { () -> Void in
//                            self.tableView?.reloadData()
//                        })
//                        
//                    } catch let err {
//                        print(err)
//                    }
//                    
//                    
//                }).resume()
//            }
//            
//            
//        
//    }

    var article: Video?
    
    fileprivate let headerId = "headerId"
    
    fileprivate let descriptionCellId = "descriptionCellId"
    
    fileprivate var contentHeight: CGFloat = 0
    
    fileprivate var cHeight: CGFloat = 0
    
    fileprivate var counter: Int = 0
    
    func fetchArticleContent() {
        
        //let parameters = ["ItemId": "7255" as AnyObject, "UserId": "4386" as AnyObject] as Dictionary<String, AnyObject>
        //let i = article!.itemid
        //let itemid = String(describing: article!.itemid)
        let parameters = ["ItemId": itemid as AnyObject, "UserId": "4386" as AnyObject] as Dictionary<String, AnyObject>
        
        var jsonData: Data
        var jsonString: String = ""
        let url = "http://pcapi.azurewebsites.net/api/LandingContainer?input="
        
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
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                print(error)
                return
            }
            print("inside json1")
            do {
                
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    let appDetail = Video()
                    if let con = (convertedJsonIntoDict["Content"] as? String) {
                        appDetail.content = con
                    }

                    
                    //self.article!.content = (convertedJsonIntoDict["Content"] as? String)!
                    
                    //appDetail.setValuesForKeysWithDictionary(json as! [String: AnyObject])
                    
                    self.article?.content = appDetail.content
                    
                }
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
                
            }
                
            catch let jsonError {
                print(jsonError)
            }
            
            
            } .resume()
        
    }
    
    override func viewDidLoad() {
        
        UserDefaults.standard.set("1", forKey: "Refresh")
        
        tableView?.alwaysBounceVertical = true
        
        //fetchArticleContent()
        
        super.viewDidLoad()
        
        tableView?.backgroundColor = UIColor.white
        
        tableView.register(ArticleContent.self, forCellReuseIdentifier: descriptionCellId)
        tableView.register(ArticleDetailHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        
        tableView.sectionHeaderHeight = 400
        //tableView.backgroundColor = UIColor.white
        tableView.allowsSelection = false
        
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellId, for: indexPath) as! ArticleContent
        
        cell.textView.text = article?.content
        
        
        var HTMLToBeReturned = cell.textView.text
        
        let string2del = "alt=\"\""
        let width = self.view.frame.width - 40
        //let widthString = width.description
        let widthString = "100%"
        HTMLToBeReturned = HTMLToBeReturned?.replacingOccurrences( of: string2del, with: "width=\""+widthString+"\"")
        
        cell.webV.loadHTMLString(HTMLToBeReturned!, baseURL: URL(string: "http://passionconnect.in"))
        //let html = cell.webV.loadHTMLString(HTMLToBeReturned!, baseURL: URL(string: "http://passionconnect.in"))

        var result = cell.webV.stringByEvaluatingJavaScript(from: "document.body.offsetHeight;")
        cell.webV.delegate = self
        if counter == 0 {
            //contentHeight = cell.webV.scrollView.contentSize.height + 300
            //cell.webV.scalesPageToFit = true
            counter = 1
        }
        
        //var result webViewll.webV.stringByEvaluatingJavaScript(fromString: "document.body.offsetHeight;")!
        let n = NumberFormatter().number(from: result!)
        //height = Double(n!)
        //contentHeight = CGFloat(height)
        return cell
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        let sectionHeaderHeight = CGFloat(400)
        
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);

        }
        else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
      
    }
    
    
    fileprivate func descriptionAttributedText() -> NSAttributedString {
        
        let attributedText = NSMutableAttributedString(string: descriptionCellId, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
        return attributedText
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
         let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! ArticleDetailHeader
        header.article = article
        //header.backgroundColor = UIColor.white
        header.contentView.backgroundColor = UIColor.white
        

        
        
        return header
    }
//    func webViewDidFinishLoad(webView: UIWebView) {
//        contentHeight = webView.scrollView.contentSize.height
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if counter == 1  {
         //cHeight = cHeight + contentHeight
         
        }
        var c = cHeight
        if c > contentHeight {
            c = c - contentHeight
        }
        if contentHeight > view.frame.height {
        return (contentHeight)//Choose your custom row height
        }
        else {
            return (view.frame.height)
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        var result = webView.stringByEvaluatingJavaScript(from: "document.body.offsetHeight;")
//        
////        if counter == 0 {
////            //contentHeight = cell.webV.scrollView.contentSize.height + 300
////            //cell.webV.scalesPageToFit = true
////            counter = 1
////        }
//        
//        //var result webViewll.webV.stringByEvaluatingJavaScript(fromString: "document.body.offsetHeight;")!
        //webView.frame.width = view.frame.width
        
        
        let n = NumberFormatter().number(from: result!)
        height = Double(n!)
        
        
        contentHeight = CGFloat(height + 20)
        if contentHeight == cHeight {
            
            return
        }
        cHeight = contentHeight
        tableView.reloadData()
//        
   }
    
    
    
}

class ArticleContent: UITableViewCell {
    

    var myTableViewController: ArticleDetailController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupViews() {
        
        
        self.webV.contentMode = UIViewContentMode.scaleAspectFit
        
        addSubview(webV)

        webV.scrollView.isScrollEnabled = false
        //webV.stringByEvaluatingJavaScript(from: String)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: webV)
        
        addConstraintsWithFormat("V:|-4-[v0]-4-|", views: webV)
        
    }
    
    let webV:UIWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    
    let textView: UITextView = {
        let tv = UITextView()
        //tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "Sample Text"
        return tv
    }()
    
}

class ArticleDetailHeader: UITableViewHeaderFooterView {
    
    var article: Video? {
        didSet {
            if let imageName = article?.thumbnailImageName {
                imageView.loadImageUsingUrlString(imageName)
            }
            
            if let title = article?.title {
                titleLabel.text = title
            }
            
            if let name = article?.channel?.name {
                userName.text = name
            }
            if let profileImage = article?.channel?.profileImageName {
                userProfileImageView.loadImageUsingUrlString(profileImage)
            }
        }
    }
    
    let imageView: CustomImageView = {
        let iv = CustomImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = UIColor.yellow
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true

        return iv
    }()
    
    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "mark")
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name"
        label.font = UIFont(name: "SanFranciscoDisplay-Black", size: 14)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mark - Blank Space palo Alto California is the headquarter of Facebook"
        label.font = UIFont(name: "SanFranciscoDisplay-Black", size: 20)
        label.numberOfLines = 2
        return label
    }()
    
    
    override init(reuseIdentifier: String?)
    {
        
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(userProfileImageView)
        addSubview(userName)
        
        addConstraintsWithFormat("H:|[v0]|", views: imageView)
        addConstraintsWithFormat("H:|-2-[v0]-2-|", views: titleLabel)
        addConstraintsWithFormat("H:|[v0(44)]|", views: userProfileImageView)
        
        addConstraintsWithFormat("V:|[v0(250)]-5-[v1(50)]", views: imageView, titleLabel)
        
        //profielImage
        //UserName
        //top constraint
        addConstraint(NSLayoutConstraint(item: userProfileImageView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 2))
        
        //left constraint
        //addConstraint(NSLayoutConstraint(item: userName, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        
        //right constraint
        //addConstraint(NSLayoutConstraint(item: userName, attribute: .right, relatedBy: .equal, toItem: thumbNailImageView, attribute: .right, multiplier: 1, constant: 0))
        //height constraint
        addConstraint(NSLayoutConstraint(item: userProfileImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 44))
        
        
        
        //UserName
        //top constraint
        addConstraint(NSLayoutConstraint(item: userName, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 17))
        
        //left constraint
        addConstraint(NSLayoutConstraint(item: userName, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        
        //right constraint
        //addConstraint(NSLayoutConstraint(item: userName, attribute: .right, relatedBy: .equal, toItem: thumbNailImageView, attribute: .right, multiplier: 1, constant: 0))
        //height constraint
        addConstraint(NSLayoutConstraint(item: userName, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 18))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


