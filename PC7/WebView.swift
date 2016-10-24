//
//  WebView.swift
//  PC7
//
//  Created by apple on 8/14/16.
//  Copyright © 2016 PassionConnect. All rights reserved.
//

import UIKit

class WebView: UIViewController {
    
    var url: Video?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webV:UIWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        let escapedString = (url?.relatedurl)!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
        let URL = Foundation.URL(string: escapedString!)
        let request = URLRequest(url: URL!)
        
        
        webV.loadRequest(request)
        view.addSubview(webV)
        
    }
}
