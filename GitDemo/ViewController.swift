//
//  ViewController.swift
//  GitDemo
//
//  Created by Nattawut Singhchai on 1/24/16.
//  Copyright © 2016 Nattawut Singhchai. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewController: UIViewController {

    @IBOutlet weak var backgroundAvatarView: UIImageView!
    @IBOutlet weak var avatarView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupView()
        
    }
    
    func setupView() {
        let size = Int(avatarView.frame.width * UIScreen.mainScreen().scale)
        avatarView.layer.cornerRadius = avatarView.frame.width / 2
        avatarView.clipsToBounds = true
        let url = NSURL(string: "https://graph.facebook.com/100000410630735/picture?width=\(size)&height=\(size)")!
        avatarView.af_setImageWithURL(url,
            imageTransition: UIImageView.ImageTransition.CrossDissolve(0.3))
        backgroundAvatarView.af_setImageWithURL(url)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

