//
//  HeaderView.swift
//  PC7
//
//  Created by apple on 8/19/16.
//  Copyright © 2016 PassionConnect. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var article: String?
    
    
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
                    
                    self.article = appDetail.content
                    
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
        super.viewDidLoad()
        
        self.tableView.tableHeaderView = HeaderView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200));
        self.tableView.register(HeaderView.self, forCellReuseIdentifier: "cellId")
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = self.tableView.tableHeaderView as! HeaderView
        
        headerView.scrollViewDidScroll(scrollView)
        
    }
}

class HeaderView: UIView {
    
    var heightLayoutConstraint = NSLayoutConstraint()
    var bottomLayoutConstraint = NSLayoutConstraint()
    
    var containerView = UIView()
    var containerLayoutConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        // The container view is needed to extend the visible area for the image view
        // to include that below the navigation bar. If this container view isn't present
        // the image view would be clipped at the navigation bar's bottom and the parallax
        // effect would not work correctly
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.red
        self.addSubview(containerView)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["containerView" : containerView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[containerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["containerView" : containerView]))
        containerLayoutConstraint = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0.0)
        self.addConstraint(containerLayoutConstraint)
        
        let imageView: UIImageView = UIImageView.init()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.white
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "mark")
        
        let content: UITextView = UITextView.init()
        containerView.addSubview(imageView)
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["imageView" : imageView]))
        bottomLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        containerView.addConstraint(bottomLayoutConstraint)
        heightLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: containerView, attribute: .height, multiplier: 1.0, constant: 0.0)
        containerView.addConstraint(heightLayoutConstraint)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        containerLayoutConstraint.constant = scrollView.contentInset.top;
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top);
        containerView.clipsToBounds = offsetY <= 0
        bottomLayoutConstraint.constant = offsetY >= 0 ? 0 : -offsetY / 2
        heightLayoutConstraint.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
}
