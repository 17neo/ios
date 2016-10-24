//
//  Video.swift
//  PC7
//
//  Created by apple on 7/27/16.
//  Copyright © 2016 PassionConnect. All rights reserved.
//

import UIKit

class Video: NSObject {
    
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: NSNumber?
    var uploadDate: Date?
    var channel: Channel?
    var userid: NSNumber?
    var relatedurl: String?
    var content: String?
    var desc: String?
    var source: String?
    var views: Int?
    var itemid: Int?
    var liked: String?
    var category: String?

}

class Channel: NSObject{
    var name: String?
    var profileImageName: String?
    
}

class Passions: NSObject {
    var title: String?
    var id: String?
    var selected: Bool?
    var itemId: Int?
}

//class Questions: NSObject {
//    var id: Int?
//    var question: String?
//    
//}




