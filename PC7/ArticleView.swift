//
//  articleDetailController.swift
//  PC7
//
//  Created by apple on 8/3/16.
//  Copyright © 2016 PassionConnect. All rights reserved.
//

import UIKit

class ArticleView: UICollectionViewController, UICollectionViewDelegateFlowLayout  {
    
    var article: Video? {
        didSet {
            
            let parameters = ["ItemId": "7255" as AnyObject, "UserId": "4386" as AnyObject] as Dictionary<String, AnyObject>
            
            
            var jsonData: Data
            var jsonString: String = ""
            //var content: String = ""
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
            
            
            URLSession.shared.dataTask(with: URL(string: s1)!, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print(error)
                    return
                }
                
                do {
                    
                    
                    
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        
                        let appDetail = Video()
                        appDetail.content = (convertedJsonIntoDict["Content"] as? String)!
                        
                        //self.article!.content = (convertedJsonIntoDict["Content"] as? String)!
                        
                        //appDetail.setValuesForKeysWithDictionary(json as! [String: AnyObject])
                        
                        self.article?.content = appDetail.content
                        
                    }
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.collectionView?.reloadData()
                    })
                    
                } catch let err {
                    print(err)
                }
                
                
            }).resume()
        }
        
        
        
    }
    fileprivate let headerId = "headerId"
    fileprivate let descriptionCellId = "descriptionCellId"
    
    
    func fetchArticleContent() {
        
        let parameters = ["ItemId": "7255" as AnyObject, "UserId": "4386" as AnyObject] as Dictionary<String, AnyObject>
        
        
        var jsonData: Data
        var jsonString: String = ""
        //var content: String = ""
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
                    appDetail.content = (convertedJsonIntoDict["Content"] as? String)!
                    
                    //self.article!.content = (convertedJsonIntoDict["Content"] as? String)!
                    
                    //appDetail.setValuesForKeysWithDictionary(json as! [String: AnyObject])
                    
                    self.article?.content = appDetail.content
                    
                }
                DispatchQueue.main.async {
                    self.collectionView!.reloadData()
                }
                
            }
                
            catch let jsonError {
                print(jsonError)
            }
            
            
            } .resume()
        
    }
    
    override func viewDidLoad() {
        
        collectionView?.alwaysBounceVertical = true
        
        fetchArticleContent()
        
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(ArticleDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        
        collectionView?.register(ArticleContent.self, forCellWithReuseIdentifier: descriptionCellId)
        
        
    }
    
        override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! ArticleDetailHeader1
    
            header.article = article
    
            return header
        }
    
    
    
    
    
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionCellId, for: indexPath) as! ArticleContent1
    
            cell.textView.text = article?.content
            //cell.article = article
            var HTMLToBeReturned = cell.textView.text
    
            let string2del = "alt=\"\""
            let width = self.view.frame.width - 40
            let widthString = width.description
            HTMLToBeReturned = HTMLToBeReturned?.replacingOccurrences( of: string2del, with: "width=\""+widthString+"\"")
    
            cell.webV.loadHTMLString(HTMLToBeReturned!, baseURL: URL(string: "http://passionconnect.in"))
            cell.article = article
            //cell.textView.text = article?.content
            
    
            return cell
        }
    
    
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 1
        }
    
    
    
    
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: view.frame.width, height: 300)
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: view.frame.width, height: 500)
        }
    
    
    
}

class ArticleContent1: BaseCell {
    
    var article: Video? {
        didSet {
            if let imageName = article?.thumbnailImageName {
                imageView.loadImageUsingUrlString(imageName)
            }
            
            if let title = article?.title {
                titleLabel.text = title
            }
        }
    }
    
    var myTableViewController: ArticleView?

    override func setupViews() {
        super.setupViews()
        
        
        self.webV.contentMode = UIViewContentMode.scaleAspectFit
        
        addSubview(webV)
        addSubview(titleLabel)
        addSubview(imageView)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: webV)
        addConstraintsWithFormat("H:|[v0]|", views: imageView)
        addConstraintsWithFormat("H:|[v0]|", views: titleLabel)
        
        //addConstraintsWithFormat("V:|[v0]-10-[v1]|", views: imageView, titleLabel)
        addConstraintsWithFormat("V:|v0(175)]-10-[v1]-4-[v2]-4-|", views: imageView, titleLabel, webV)
        //addConstraintsWithFormat("V:|[v0]-10-[v1]-4-[v2]-4-|", views: imageView, titleLabel, webV)
        
    }
    
    let webV:UIWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    
    let textView: UITextView = {
        let tv = UITextView()
        //tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "Sample Text"
        return tv
    }()
    
    
    let imageView: CustomImageView = {
        let iv = CustomImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = UIColor.yellow
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mark - Blank Space palo Alto California is the headquarter of Facebook"
        label.numberOfLines = 2
        return label
    }()
    
    
}

class ArticleDetailHeader1: BaseCell {
    
    var article: Video? {
        didSet {
            if let imageName = article?.thumbnailImageName {
                imageView.loadImageUsingUrlString(imageName)
            }
            
            if let title = article?.title {
                titleLabel.text = title
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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mark - Blank Space palo Alto California is the headquarter of Facebook"
        label.numberOfLines = 2
        return label
    }()
    
    
    
    override func setupViews() {
        super.setupViews()
        addSubview(imageView)
        addSubview(titleLabel)
        
        //imageView.backgroundColor = UIColor.yellowColor()
        //imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintsWithFormat("H:|[v0]|", views: imageView)
        addConstraintsWithFormat("H:|[v0]|", views: titleLabel)
        addConstraintsWithFormat("V:|[v0(175)]-10-[v1]|", views: imageView, titleLabel)
    }
    
}







