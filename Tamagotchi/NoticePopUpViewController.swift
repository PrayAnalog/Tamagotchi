//
//  NoticePopUpViewController.swift
//  Tamagotchi
//
//  Created by user on 2017. 7. 23..
//  Copyright © 2017년 user. All rights reserved.
//

import UIKit

class NoticePopUpViewController: UIViewController {

    @IBOutlet weak var noticePopUpView: UIView!
    @IBOutlet weak var noticeAnimationImageView: UIImageView!
    @IBOutlet weak var noticeViewCloseButton: UIButton!
    public var species: String?
    public var animation: String?
    public var animationTime = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        noticePopUpView.layer.cornerRadius = 15.0
        noticeViewCloseButton.layer.cornerRadius = 12.0
        
        var imageListArray: [UIImage] = []
        
        for i in 0..<2 {
            var image: UIImage?
            if (animation == "clean") {
                image = UIImage(named: animation! + String(i))
            } else {
                image = UIImage(named: species! + "sayno" + String(i))
            }
            imageListArray.append(image!)
        }
        
        noticeAnimationImageView.animationImages = imageListArray
        noticeAnimationImageView.animationDuration = 1
        noticeAnimationImageView.animationRepeatCount = 2
        noticeAnimationImageView.startAnimating()
        
        // after animation finish, remove popup view itself
        Timer.scheduledTimer(withTimeInterval: animationTime, repeats: false, block: {_ in self.closePopUp() })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func closePopUp() {
        self.view.removeFromSuperview()
    }
    
    // close button pressed
    @IBAction func closePopUp(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }

}
