//
//  SelectPassion.swift
//  PC7
//
//  Created by apple on 8/17/16.
//  Copyright © 2016 PassionConnect. All rights reserved.
//

//
//  ViewController.swift
//  mytableview1
//
//  Created by Brian Voong on 2/23/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

var selectedPassionGlobal: [Int] = [0]


class SelectPassion: UITableViewController {
    
    var passions: [Passions]?
    
    var selectedPassions: [Int]?
    
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
                    
                    self.passions = [Passions]()
                    self.selectedPassions = [Int]()
                    
                    for dictionary in json as! [[String: AnyObject]] {
                        
                        let p = Passions()
                        
                        
                        p.title = dictionary["Description"] as? String
                        p.itemId = dictionary["ID"] as? Int
                        p.selected = dictionary["Selected"] as? Bool
                        
                        if p.selected == true {
                            self.selectedPassions?.append(p.itemId!)
                        }
                        self.passions?.append(p)
                        selectedPassionGlobal = self.selectedPassions!
                    }
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.tableView?.reloadData()
                    })
                    
                } catch let err {
                    print(err)
                }
                
                
            }).resume()
        }
        
        
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPassions()
        //print(selectedPassions)
        navigationItem.title = "My TableView"
        
        tableView.register(MyCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
        
        tableView.sectionHeaderHeight = 300
        tableView.allowsSelection = false
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Go", style: .plain, target: self, action: #selector(SelectPassion.insert))
        self.navigationItem.hidesBackButton = true

        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Batch Insert", style: .Plain, target: self, action: "insertBatch")
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passions?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MyCell
        //myCell.nameLabel.text = items[indexPath.row]
        myCell.nameLabel.text = passions![(indexPath as NSIndexPath).row].title
        let selP = passions![(indexPath as NSIndexPath).row].selected
            //button.setImage(UIImage(named: "plus"), for: UIControlState())
        myCell.actionButton.isSelected = selP!
       // self.selectedPassions = [Int]()
        
        if selP == true {
            myCell.actionButton.setImage(UIImage(named:"minus"), for: UIControlState())
            
            let i = passions![(indexPath as NSIndexPath).row].itemId!
            //self.selectedPassions?.append(passions![(indexPath as NSIndexPath).row].itemId!)
         //   self.selectedPassions?.append(i)
            //self.selectedPassions?.append(1)
           // print(self.selectedPassions)
            
        }
        myCell.myTableViewController = self
        
        myCell.selectedPassions = self.selectedPassions!
        
        myCell.passionid = passions![(indexPath as NSIndexPath).row].itemId!

        return myCell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") as! Header
        header.contentView.backgroundColor = UIColor.white
        header.myTableViewController = self
        
        return header
    }
    
    func insert() {
        print("Go")
        //let home = HomeController()
        //home.p = self.selectedPassions!
        //self.navigationController?.pushViewController(home, animated: true)
        
        //UserDefaults.standard.set(selectedPassions, forKey: "p")

        self.navigationController?.popToRootViewController(animated: true)
        
    }
    func TakeTest1() {
        let myArray = UserDefaults.standard.object(forKey: "answers") as! [String]
        let result = UserDefaults.standard.string(forKey: "TestResult")
        if result == nil {
            let controller = TakePassionTest()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else {
            let controller = ResultView()
            controller.url = result!
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.isNavigationBarHidden = false

    }

    
    
}

class Header: UITableViewHeaderFooterView {
    
    var myTableViewController: SelectPassion?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "My Header"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let passionTest: UIButton = {
        let button = UIButton(type: .system)
        //button.setTitle("Delete", forState: .Normal)
        //button.setImage(UIImage(named: "plus"), for: UIControlState())
        //button.setValue("selected", forKey: "selected")
        //button.isSelected = false
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.tintColor = UIColor.orange
        button.setTitle("Take Passion Test", for: .normal)
        return button
    }()
    
    let headerImage: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "selectpassion")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        addSubview(headerImage)
        addSubview(passionTest)
        //passionTest.textAlignment = NSTextAlignment.center
        passionTest.addTarget(self, action: #selector(Header.TakeTest), for: .touchUpInside)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": passionTest]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": headerImage]))
        addConstraintsWithFormat("V:|[v0(250)]-5-[v1(30)]", views: headerImage, passionTest)
        
    }
    
    func TakeTest() {
//        let sp : SelectPassion?
//        let controller = TakePassionTest()
//        myTableViewController?.navigationController?.pushViewController(controller, animated: true)
        
        let myArray = UserDefaults.standard.object(forKey: "answers") as? [String]
        let result = UserDefaults.standard.string(forKey: "TestResult")
        if result == nil {
//            if myArray?.count == 0 {
            let controller = TakePassionTest()
            myTableViewController?.navigationController?.pushViewController(controller, animated: true)
//            }
//            else {
//                let controller = QuestionController()
//                //controller.questionList = self.questionsList
//                //questionsList = self.questionsList1
//                let ques = UserDefaults.standard.object(forKey: "questions")
//                questionsList = ques as! [Question]?
//                myTableViewController?.navigationController?.pushViewController(controller, animated: true)
// 
//            }
        }
        else {
            let controller = ResultView()
            controller.url = result!
            myTableViewController?.navigationController?.pushViewController(controller, animated: true)
        }
        
    //SelectPassion.TakeTest1(sp!)
        //sp?.TakeTest1()
    }
    
    
    
    
    
    
}

class MyCell: UITableViewCell {
    
    var myTableViewController: SelectPassion?
    
    var selectedPassions: [Int] = [0]
    
    var passionid = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Item"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    

    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setTitle("Delete", forState: .Normal)
        button.setImage(UIImage(named: "plus"), for: UIControlState())
        //button.setValue("selected", forKey: "selected")
        button.isSelected = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.orange
        return button
    }()
    
    
    func setupViews() {
        addSubview(nameLabel)
        addSubview(actionButton)
        
        actionButton.addTarget(self, action: #selector(MyCell.handleAction), for: .touchUpInside)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-8-[v1(80)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": actionButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": actionButton]))
        
    }
    
    func handleAction() {
        //myTableViewController?.deleteCell(self)
        print(selectedPassionGlobal)
        let val = self.actionButton.isSelected
        
        if val == false {
        self.actionButton.setImage(UIImage(named:"minus"), for: UIControlState())
        self.actionButton.isSelected = true
        
        selectedPassionGlobal.append(self.passionid)
            }
        else {
            self.actionButton.setImage(UIImage(named:"plus"), for: UIControlState())
            self.actionButton.isSelected = false
            let pid = self.passionid
            if let index = selectedPassionGlobal.index(of: pid) {
                selectedPassionGlobal.remove(at: index)
            }

        
        }
        UserDefaults.standard.set(selectedPassionGlobal, forKey: "p")
        UserDefaults.standard.set(true, forKey: "updatepassion")
        let myArray = UserDefaults.standard.object(forKey: "p") as? [Int]
        print(myArray)
        print(selectedPassionGlobal)
        
    }
    
    
   

    
}
