import UIKit

//struct Question {
//    var questionString: String?
//    var answers: [String]?
//    var selectedAnswerIndex: Int?
//}

//var questionsList: [Question]?

class QuestionController: UITableViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
    var answers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignbackground()
        navigationItem.title = "Question"
        
        navigationController?.navigationBar.tintColor = UIColor.white
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(home))

        tableView.register(AnswerCell.self, forCellReuseIdentifier: cellId)
        tableView.register(QuestionHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        
        tableView.sectionHeaderHeight = 70
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//         var index = UserDefaults.standard.integer(forKey: "questionnumber")
//            let question = questionsList![index]
//            if let count = question.answers?.count {
//                return count
//            }
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AnswerCell
        
//        if let index = navigationController?.viewControllers.index(of: self) {
//            let question = questionsList![index]
//            cell.nameLabel.text = question.answers?[(indexPath as NSIndexPath).row]
//        }
        var index = UserDefaults.standard.integer(forKey: "questionnumber")
        let question = questionsList![index]
        cell.nameLabel.text = question.answers?[(indexPath as NSIndexPath).row]
       
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! QuestionHeader
        
        var index = UserDefaults.standard.integer(forKey: "questionnumber")
        let question = questionsList![index]
        header.nameLabel.text = question.questionString
        
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var myArray = UserDefaults.standard.object(forKey: "answers") as! [String]
        var index = UserDefaults.standard.integer(forKey: "questionnumber")
            questionsList![index].selectedAnswerIndex = (indexPath as NSIndexPath).item
            print(indexPath)
            print(questionsList![index].selectedAnswerIndex)
            if questionsList![index].selectedAnswerIndex == 0 {
                myArray.append("1")
            }
            else {
                myArray.append("0")
            }
            
            print (myArray)
            UserDefaults.standard.set(myArray, forKey: "answers")
            if index < questionsList!.count - 1 {
                //FetchResult()
                let questionController = QuestionController()
                navigationController?.pushViewController(questionController, animated: true)
                
                index = index + 1
                UserDefaults.standard.set(index, forKey: "questionnumber")
            } else {
                
                FetchResult()
                //let controller = ResultsController()
                //navigationController?.pushViewController(controller, animated: true)
            }
        
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
    
    func home() {
     
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func FetchResult() {
    
//        var index = 0
//        var ans : [String]?
//        
//        while index < questionsList!.count {
//            if questionsList![index].selectedAnswerIndex == 0 {
//                ans![index] = "1"
//            }
//            else {
//                ans![index] = "0"
//            }
//            index += 1
//        }
        
        //var ans: [String] = ["1","0","1","0","1","0","1","0","1","0","1","0","1","0","1","0","1","0","0","1","0","1","0","1","0","1","1","1","0","1","0","1","0","0","1","0","1","0","0","0","1","0","1","0","1","0","1","0","1","0","1","0","1","0","1","0","1","1","0","1","0","1","0","1","0","1","0","1","0","1","0","0","1","0","1","0","1","0","1","1","0","1","0","1","0","1","0","1","0","1"]
    
    let ans = UserDefaults.standard.object(forKey: "answers") as! [String]
        
    let parameters = ["UserId": "5723" as AnyObject, "Answers": ans as AnyObject] as Dictionary<String, AnyObject>
    
    
    var jsonData: Data
    var jsonString: String = ""
    let url = "http://pcapi.azurewebsites.net/api/Questions?answers="
    
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
    
    
        let responseStr:NSString = NSString(data:data!, encoding:String.Encoding.utf8.rawValue)!
        print("responseStr" + (responseStr as String))
        
        
        
        
        
        self.dismiss(animated: true, completion:nil)
        
        DispatchQueue.main.async{
            let controller = ResultView()
            //controller.questionList = self.questionsList
            //questionsList = self.questionsList1
            //let url1 = NSURL (URLWithString: responseStr as String)
            //controller.url = URL(string: responseStr as String)
            controller.url = responseStr as String
            let testResult = controller.url.replacingOccurrences(of: "\"", with: "")
            UserDefaults.standard.set(testResult, forKey: "TestResult")
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
        
        } .resume()

    }
    
}

//class ResultsController: UIViewController {
//
//    let resultsLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Congratulations, you're a total Ross!"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .Center
//        label.font = UIFont.boldSystemFontOfSize(14)
//        return label
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "done")
//
//        navigationItem.title = "Results"
//
//        view.backgroundColor = UIColor.whiteColor()
//
//        view.addSubview(resultsLabel)
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": resultsLabel]))
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": resultsLabel]))
//        
//        let names = ["Ross", "Joey", "Chandler", "Monica", "Rachel", "Phoebe"]
//        
//        var score = 0
//        for question in questionsList! {
//            score += question.selectedAnswerIndex!
//        }
//        
//        let result = names[score % names.count]
//        resultsLabel.text = "Congratulations, you're a total \(result)!"
//    }
//    
//    func done() {
//        navigationController?.popToRootViewControllerAnimated(true)
//    }
//    
//}

class QuestionHeader: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Question"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        return label
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class AnswerCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Answer"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }
    
}
