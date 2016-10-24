//
//  LeftSlideHeader.swift
//  PC7
//
//  Created by apple on 10/17/16.
//  Copyright © 2016 PassionConnect. All rights reserved.
//

import UIKit

class LeftSlideHeader: BaseCell {
    
    
    
    override var isSelected: Bool {
        didSet {
            
            backgroundColor = UIColor.white
            
            nameLabel.textColor = UIColor.black
            
            iconImageView.tintColor = UIColor.darkGray
        }
    }
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Shubham Deva"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "mark")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        
        addSubview(nameLabel)
        addSubview(iconImageView)
        
        
        
        addConstraintsWithFormat("H:|-8-[v0(30)]-8-[v1]|", views: iconImageView, nameLabel)
        
        
        addConstraintsWithFormat("V:|-10-[v0(30)]", views: nameLabel)
        addConstraintsWithFormat("V:|-10-[v0(30)]", views: iconImageView)
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
