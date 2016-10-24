//
//  TakePassionTest.swift
//  PC7
//
//  Created by apple on 8/30/16.
//  Copyright © 2016 PassionConnect. All rights reserved.
//

import UIKit

struct Question {
    var questionString: String?
    var answers: [String]?
    var selectedAnswerIndex: Int?
}

var questionsList: [Question]?

class TakePassionTest:  UIViewController, UITextFieldDelegate {
    
    var questionsList1: [Question]?
    
    var textField : UITextField!
    var label : UILabel!
    let str : String = "You have entered:"
    var answers = [String]()
    
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        //button.setImage(UIImage(named: "plus"), forState: .Normal)
        //button.setValue("selected", forKey: "selected")
        button.isSelected = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.orange
        
        
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        let index = UserDefaults.standard.integer(forKey: "questionnumber")
        if index > 0 {
            LoadQuestions()
        }
        else {
            UserDefaults.standard.set(answers, forKey: "answers")
            UserDefaults.standard.set(0, forKey: "questionnumber")
        }
        //view.backgroundColor = UIColor.white
        //view.backgroundColor = UIColor.yellow
        assignbackground()
        
        let placeholder = NSAttributedString(string: "Enter Coupon Code", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        textField = UITextField(frame: CGRect(x: 90, y: 100, width: 200, height: 30))
        
        textField.attributedPlaceholder = placeholder
        textField.textColor = UIColor.black
        textField.delegate = self
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.clearsOnBeginEditing = true
        view.addSubview(textField)
        
        label = UILabel(frame: CGRect(x: 90, y: 200, width: 200, height: 30))
        label.text = str
        //view.addSubview(label)
        view.addSubview(nextButton)
        
        nextButton.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        //nextButton.center = CGPoint(x: self.view.bounds.size.width / 2, y: 30)
        //.nextButton.
        self.view.addConstraintsWithFormat("H:|-16-[v0]-16-|", views: nextButton)
        self.view.addConstraintsWithFormat("V:|-200-[v0(40)]", views: nextButton)
        
    }
    
    func handleAction() {
        
        let parameters = ["CouponCode": "LiveYourPassion", "UserId": "5723"] as Dictionary<String, String>
        
        
        var jsonData: Data
        var jsonString: String = ""
        let url = "http://pcapi.azurewebsites.net/api/Questions?couponDetails="
        
        do{
            jsonData = try JSONSerialization.data(withJSONObject: parameters, options: []) as NSData as Data
            print(jsonData)
            jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue) as! String
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
            print("responseStr" + (responseStr as String))
      
            
            
            
            
            self.dismiss(animated: true, completion:nil)
            
            DispatchQueue.main.async {
                //self.navigationController?.popToRootViewControllerAnimated(true)
                if responseStr == "1" {
                    self.LoadQuestions()
                }
            }
            
            }.resume()
        
        
    }
    
    func LoadQuestions() {
        
        //let parameters = ["ItemId": "7255", "UserId": "4386"] as Dictionary<String, AnyObject>
        
        
        
        //let url = "http://pcapi.azurewebsites.net/api/article?UserId=4386"
        
        let url = "http://pcapi.azurewebsites.net/api/Questions"
        
        URLSession.shared.dataTask(with: URL(string: url)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                
                
                
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                self.questionsList1 = [Question]()
                
                for dictionary in json as! [[String: AnyObject]] {
                    
                    var p = Question()
                    
                    p.questionString = dictionary["Description"] as? String
                    //p. = dictionary["ID"] as? String
                    p.answers = ["Like", "Dislike"]
                    p.selectedAnswerIndex = nil
                    self.questionsList1?.append(p)
                    
                }
                
                DispatchQueue.main.async (execute: { () -> Void in
                    //self.tableView?.reloadData()
                    let controller = QuestionController()
                    //controller.questionList = self.questionsList
                    questionsList = self.questionsList1
                    //UserDefaults.standard.set(questionsList, forKey: "questions")
                    self.navigationController?.pushViewController(controller, animated: true)

                    
                })
                
            } catch let err {
                print(err)
            }
            
            
        }).resume()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Display the result.
        label.text = textField.text!
        
        //Color #4 - After pressing the return button
        view.backgroundColor = UIColor.orange
        
        textField.resignFirstResponder() //Hide the keyboard
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func assignbackground(){
        let background = UIImage(named: "test-bg")
        
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
