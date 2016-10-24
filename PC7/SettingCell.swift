//
//  SettingCell.swift
//  PC7
//
//  Created by apple on 8/1/16.
//  Copyright © 2016 PassionConnect. All rights reserved.
//

import UIKit

class SettingCell: BaseCell {
    
    
    
    override var isSelected: Bool {
        didSet {
            
            backgroundColor = isSelected ? UIColor.darkGray : UIColor.white
            
            nameLabel.textColor = isSelected ? UIColor.white : UIColor.black
            
            iconImageView.tintColor = isSelected ? UIColor.white : UIColor.darkGray
        }
    }
    
    var setting: Passions? {
        didSet {
            nameLabel.text = setting?.title
            
            if let imageName = setting?.id {
                iconImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
                iconImageView.tintColor = UIColor.darkGray
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Setting"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "like1")
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
