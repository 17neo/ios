//
//  VideoCell.swift
//  PC7
//
//  Created by apple on 7/27/16.
//  Copyright © 2016 PassionConnect. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoCell: BaseCell{
    var item = 0
    var video: Video? {
        didSet {
          titleLabel.text = video?.title
          subtitleTextView.text = video?.channel?.name
          descView.text = video?.desc
          source.text = video?.source
            itemId.text = String(describing: video?.itemid!)
            //print(video?.itemid)
            item = (video?.itemid)!
            category.text = video?.category
          
          if let numberOfViews = video?.views {
          let numberFormatter = NumberFormatter()
          numberFormatter.numberStyle = .decimal
            
            
          let subtitleText = "\(numberFormatter.string(from: numberOfViews as NSNumber)!)"
            views.text = subtitleText
            }
          
          
            
            setupThumbnailImage()
            
            setupProfileImage()
            
            
            //if let channelName = video?.channel?.name, numberOfViews = video?.numberOfViews {
                
//                let numberFormatter = NSNumberFormatter()
//                numberFormatter.numberStyle = .DecimalStyle
//                
//              
//                let subtitleText = "\(channelName) \(numberFormatter.stringFromNumber(numberOfViews)!)"
                
                //subtitleTextView.text = subtitleText
                //descView.text = subtitleText
                
                
            //}
            
            //measure title text
            
            if let title = video?.title {
                let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedRect = NSString(string:title).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
                if estimatedRect.size.height > 20{
                    titleLabelHeightConstraint?.constant = 44
                } else {
                    titleLabelHeightConstraint?.constant = 20
                }

            }
            
            if video?.liked == nil {
                self.likeIcon.setImage(UIImage(named:"like"), for: UIControlState())
            }
            
        }
    }
    
    func setupProfileImage() {
        if let profileImageUrl = video?.channel?.profileImageName {
            userProfileImageView.loadImageUsingUrlString(profileImageUrl)
        }
    }
    
    func setupThumbnailImage() {
        if let thumbnailImageUrl = video?.thumbnailImageName {
        
            thumbNailImageView.loadImageUsingUrlString(thumbnailImageUrl)
        }
    }
    
    
    let thumbNailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "view")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let viewsIcon: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "view")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let shareIcon: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "share")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
//    let likeIcon: CustomImageView = {
//        let imageView = CustomImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(named: "like")
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        return imageView
//    }()
    
    
    let likeIcon: UIButton = {
        let button = UIButton(type: .system)
        //button.setTitle("Delete", forState: .Normal)
        button.setImage(UIImage(named: "like"), for: UIControlState())
        //button.setValue("selected", forKey: "selected")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isSelected = false
        button.backgroundColor = UIColor.white
        //button.tintColor = UIColor.white
        return button
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
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mark - Blank Space palo Alto California is the headquarter of Facebook"
        label.font = UIFont(name: "SanFranciscoDisplay-Black", size: 18)
        label.numberOfLines = 2
        return label
    }()
    
    let category: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Travel"
        label.font = UIFont.systemFont(ofSize: 18)
        //label.font = UIFont(name: "SanFranciscoDisplay-Black", size: 18)
        label.backgroundColor = UIColor.white
        label.layer.cornerRadius = 10.0
        label.clipsToBounds = true
        //label.textAlignment = UITextAlignmentCenter
        return label
    }()
    
    let moreAt: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.text = "more at"
        return label
    }()
    
    let source: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "source"
        return label
    }()
    
    let views: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "views"
        return label
    }()
    
    let itemId: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "views"
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Mark Zuckerberg1"
        textView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        textView.textColor = UIColor.black
        textView.font = UIFont.boldSystemFont(ofSize: 14)
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    let descView: UITextView = {
        let textView1 = UITextView()
        //textView1.translatesAutoresizingMaskIntoConstraints = false
        textView1.text = "Mark Zuckerberghjvbadafhjvbadfh vadfhjbvhajdfv hadfjbvajhdfb hfdbvajdfhbv  hjfdbvhjafbdkjsdjfkv vhjadfbagerigheiurhhb vhabdfuvidfnvaidfjhbvadfhkj dfahvbadfovnaidfhvbhadfo"
        textView1.font = UIFont.systemFont(ofSize: 14)
        textView1.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        textView1.textColor = UIColor.black
        textView1.isUserInteractionEnabled = false
        return textView1
    }()
    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    override func setupViews() {
        
        addSubview(thumbNailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        addSubview(descView)
        addSubview(moreAt)
        addSubview(source)
        addSubview(viewsIcon)
        addSubview(views)
        addSubview(likeIcon)
        addSubview(shareIcon)
        addSubview(category)
        
        likeIcon.addTarget(self, action: #selector(VideoCell.handleAction), for: .touchUpInside)
        category.textAlignment = NSTextAlignment.center
        
        addConstraintsWithFormat("H:|-16-[v0]-16-|", views: thumbNailImageView)
        addConstraintsWithFormat("H:|-16-[v0]-16-|", views: titleLabel)
        addConstraintsWithFormat("H:|-16-[v0(44)]", views: userProfileImageView)
        addConstraintsWithFormat("H:|-16-[v0]-16-|", views: descView)
        addConstraintsWithFormat("H:|-16-[v0]", views: moreAt)
        addConstraintsWithFormat("H:|-250-[v0]-16-|", views: category)
        
        
        
        
        //vertical constraints
        addConstraintsWithFormat("V:|-16-[v0]-5-[v1(44)][v2(44)]-128-[v3(1)]|", views: thumbNailImageView, titleLabel, userProfileImageView, separatorView)
        addConstraintsWithFormat("V:|-25-[v0(25)]", views: category)
        addConstraintsWithFormat("H:|[v0]|", views: separatorView)
        
        //top constraint
//        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .Equal, toItem: thumbNailImageView, attribute: .Bottom, multiplier: 1, constant: 8))
//        
//        //left constraint
//        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Left, relatedBy: .Equal, toItem:  attribute: .Right, multiplier: 1, constant: 0))
//        
//        //right constraint
//        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Right, relatedBy: .Equal, toItem: thumbNailImageView, attribute: .Right, multiplier: 1, constant: 0))
//        
//        //height constraint
//        
//        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0, constant: 44)
//        addConstraint(titleLabelHeightConstraint!)
        
        
        
        
        //top constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 12))
        
        //left constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        
        //right constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: thumbNailImageView, attribute: .right, multiplier: 1, constant: 0))
        //height constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 25))
        
        //descView
        
        //top constraint
        addConstraint(NSLayoutConstraint(item: descView, attribute: .top, relatedBy: .equal, toItem: subtitleTextView, attribute: .bottom, multiplier: 1, constant: 12))
        
        //left constraint
        //addConstraint(NSLayoutConstraint(item: descView, attribute: .Left, relatedBy: .Equal, toItem: userProfileImageView, attribute: .Right, multiplier: 1, constant: 8))
        
        //right constraint
        //addConstraint(NSLayoutConstraint(item: descView, attribute: .Right, relatedBy: .Equal, toItem: thumbNailImageView, attribute: .Right, multiplier: 1, constant: 0))
        
       
        //height constraint
        addConstraint(NSLayoutConstraint(item: descView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 86))
        
        //moreAt
        
        //top constraint
        addConstraint(NSLayoutConstraint(item: moreAt, attribute: .top, relatedBy: .equal, toItem: descView, attribute: .bottom, multiplier: 1, constant: 17))
        
        //left constraint
        //addConstraint(NSLayoutConstraint(item: source, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 16))
        
        //right constraint
        //addConstraint(NSLayoutConstraint(item: source, attribute: .Right, relatedBy: .Equal, toItem: thumbNailImageView, attribute: .Right, multiplier: 1, constant: 0))
        //height constraint
        addConstraint(NSLayoutConstraint(item: moreAt, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 18))
        

        
         //source
        //top constraint
        addConstraint(NSLayoutConstraint(item: source, attribute: .top, relatedBy: .equal, toItem: descView, attribute: .bottom, multiplier: 1, constant: 17))
        
        //left constraint
        addConstraint(NSLayoutConstraint(item: source, attribute: .left, relatedBy: .equal, toItem: moreAt, attribute: .left, multiplier: 1, constant: 55))
        
        //right constraint
        //addConstraint(NSLayoutConstraint(item: source, attribute: .Right, relatedBy: .Equal, toItem: thumbNailImageView, attribute: .Right, multiplier: 1, constant: 0))
        //height constraint
        addConstraint(NSLayoutConstraint(item: source, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 18))
        
        // shareicon
        
        addConstraint(NSLayoutConstraint(item: shareIcon, attribute: .top, relatedBy: .equal, toItem: descView, attribute: .bottom, multiplier: 1, constant: 17))
        
        //left constraint
        addConstraint(NSLayoutConstraint(item: shareIcon, attribute: .left, relatedBy: .equal, toItem: moreAt, attribute: .left, multiplier: 1, constant: 190))
        
        //right constraint
        //addConstraint(NSLayoutConstraint(item: source, attribute: .Right, relatedBy: .Equal, toItem: thumbNailImageView, attribute: .Right, multiplier: 1, constant: 0))
        //height constraint
        addConstraint(NSLayoutConstraint(item: shareIcon, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 18))
        
        // viewsicon
        
        addConstraint(NSLayoutConstraint(item: viewsIcon, attribute: .top, relatedBy: .equal, toItem: descView, attribute: .bottom, multiplier: 1, constant: 17))
        
        //left constraint
        addConstraint(NSLayoutConstraint(item: viewsIcon, attribute: .left, relatedBy: .equal, toItem: moreAt, attribute: .left, multiplier: 1, constant: 220))
        
        //right constraint
        //addConstraint(NSLayoutConstraint(item: source, attribute: .Right, relatedBy: .Equal, toItem: thumbNailImageView, attribute: .Right, multiplier: 1, constant: 0))
        //height constraint
        addConstraint(NSLayoutConstraint(item: viewsIcon, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 18))
        
        //views
        
        addConstraint(NSLayoutConstraint(item: views, attribute: .top, relatedBy: .equal, toItem: descView, attribute: .bottom, multiplier: 1, constant: 17))
        
        //left constraint
        addConstraint(NSLayoutConstraint(item: views, attribute: .left, relatedBy: .equal, toItem: moreAt, attribute: .left, multiplier: 1, constant: 245))
        
        //right constraint
        //addConstraint(NSLayoutConstraint(item: source, attribute: .Right, relatedBy: .Equal, toItem: thumbNailImageView, attribute: .Right, multiplier: 1, constant: 0))
        //height constraint
        addConstraint(NSLayoutConstraint(item: views, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 18))
        
        
        // likeicon
        
        addConstraint(NSLayoutConstraint(item: likeIcon, attribute: .top, relatedBy: .equal, toItem: descView, attribute: .bottom, multiplier: 1, constant: 17))
        
        //left constraint
        addConstraint(NSLayoutConstraint(item: likeIcon, attribute: .left, relatedBy: .equal, toItem: moreAt, attribute: .left, multiplier: 1, constant: 290))
        
        //right constraint
        //addConstraint(NSLayoutConstraint(item: source, attribute: .Right, relatedBy: .Equal, toItem: thumbNailImageView, attribute: .Right, multiplier: 1, constant: 0))
        //height constraint
        addConstraint(NSLayoutConstraint(item: likeIcon, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 18))
        
        //dividerline
        
        //top constraint
        //addConstraint(NSLayoutConstraint(item: separatorView, attribute: .Top, relatedBy: .Equal, toItem: moreAt, attribute: .Bottom, multiplier: 1, constant: 6))
        
        //left constraint
        //addConstraint(NSLayoutConstraint(item: source, attribute: .Left, relatedBy: .Equal, toItem: moreAt, attribute: .Left, multiplier: 1, constant: 50))
        
        //right constraint
        //addConstraint(NSLayoutConstraint(item: source, attribute: .Right, relatedBy: .Equal, toItem: thumbNailImageView, attribute: .Right, multiplier: 1, constant: 0))
        //height constraint
        //addConstraint(NSLayoutConstraint(item: separatorView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0, constant: 1))
        

        
        
        
    }
    
    func handleAction() {
        //myTableViewController?.deleteCell(self)
        //let val = self.
        
        let val = String(self.item)
        
        let userid = UserDefaults.standard.string(forKey: "UserId")
        //let itemid = UserDefaults.standard.string(forKey: "itemid")
            self.likeIcon.setImage(UIImage(named:"like1"), for: UIControlState())
            //self.actionButton.isSelected = true
        like (itemid: val, userID: userid!)
       
    }
    
    func like(itemid: String, userID: String) {
        
        
        
        // http://pcapi.azurewebsites.net/api/UserAction?input={"ArticleId":"9307","UserId":"6192","userAction":"ArticleLike"}
        
        
        let parameters = ["ArticleId": "9307", "UserId": "6192", "userAction": "ArticleLike"] as Dictionary<String, String>
        
        
        var jsonData: Data
        var jsonString: String = ""
        let url = "http://pcapi.azurewebsites.net/api/UserAction?input="
        
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
        request.httpMethod = "POST"
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
            
            
            
            
//            self.dismiss(animated: true, completion:nil)
//            
//            DispatchQueue.main.async(execute: {
//                self.collectionView?.reloadData()
//            })
            
            
            } .resume()
        
        
    }

    
    
}
