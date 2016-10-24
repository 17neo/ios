//
//  ResultView.swift
//  PC7
//
//  Created by apple on 8/31/16.
//  Copyright © 2016 PassionConnect. All rights reserved.
//

import UIKit

class ResultView: UIViewController {
    
    var url: String = ""
    
    override func viewDidLoad() {
        url = url.replacingOccurrences(of: "\"", with: "")
        super.viewDidLoad()
        let webV:UIWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 70))
        let escapedString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
        let URL = Foundation.URL(string: escapedString!)
        let request = URLRequest(url: URL!)
        
        webV.loadRequest(request)
        view.addSubview(webV)
        
    }
}
