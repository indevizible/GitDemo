//
//  DemoHeaderView.swift
//  GitDemo
//
//  Created by Nattawut Singhchai on 1/24/16.
//  Copyright © 2016 Nattawut Singhchai. All rights reserved.
//

import UIKit
import AlamofireImage

class DemoHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var avatarView: UIImageView!
    
    @IBOutlet weak var backgroundAvatarView: UIImageView!
    
    @IBOutlet weak var visualEffectViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        avatarView.layer.cornerRadius = avatarView.frame.width / 2
        avatarView.clipsToBounds = true
    }
    
    func setName(name:String, position: String) {
        let attributedString = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Medium", size: 20)!])
        
        attributedString.appendAttributedString(NSAttributedString(string: "\n\(position)", attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 16)!]))
        
        textHeightConstraint.constant = ceil(attributedString.boundingRectWithSize(CGSize(width: nameLabel.frame.width, height: CGFloat.max), options:[.UsesFontLeading,.UsesLineFragmentOrigin]  ,context: nil).height)
        nameLabel.attributedText = attributedString
    }
    
    func setFacebookUserID(ID:String) {
        let size = Int(avatarView.frame.width * UIScreen.mainScreen().scale)
        let url = NSURL(string: "https://graph.facebook.com/\(ID)/picture?width=\(size)&height=\(size)")!
        avatarView.af_setImageWithURL(url,
            imageTransition: UIImageView.ImageTransition.CrossDissolve(0.3))
        backgroundAvatarView.af_setImageWithURL(url)
    }

}
