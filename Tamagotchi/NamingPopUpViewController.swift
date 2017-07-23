//
//  NamingPopUpViewController.swift
//  Tamagotchi
//
//  Created by user on 2017. 7. 23..
//  Copyright © 2017년 user. All rights reserved.
//

import UIKit

class NamingPopUpViewController: UIViewController {

    
    @IBOutlet weak var namingPopUpView: UIView!
    @IBOutlet weak var namingPopUpImageView: UIImageView!
    @IBOutlet weak var namingPopUpTextField: UITextField!
    @IBOutlet weak var namingPopUpCloseButton: UIButton!
    
    public var tama: Tamagotchi?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        namingPopUpView.layer.cornerRadius = 15.0
        namingPopUpCloseButton.layer.cornerRadius = 12.0
        
        // baby born image animation set
        let imageListArray: [UIImage] = [UIImage(named: "babyborn0")!, UIImage(named: "babyborn1")!]
        namingPopUpImageView.animationImages = imageListArray
        namingPopUpImageView.animationDuration = 1.0
        namingPopUpImageView.animationRepeatCount = 50
        namingPopUpImageView.startAnimating()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func checkNameClosePopUp(_ sender: UIButton) {
        if (namingPopUpTextField.text != "") && (namingPopUpTextField.text != "?"){ // have to check name is not empty space 가능하면 팝업 띄워줘서 맞냐고 확인해도 되지만 아직 안함
            namingPopUpImageView.stopAnimating()
            tama!.name = namingPopUpTextField.text!
            self.view.removeFromSuperview()
        } else {
            print("short name") // 이름이 짧다고 팝업 띄워줘야 한다. 귀찮다. 아직 안했다.
        }
    }

}
