//
//  HomeViewController.swift
//  Tamagotchi
//
//  Created by user on 2017. 7. 20..
//  Copyright © 2017년 user. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var petImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func eatAnimation() {
        
        let petImageNameDefault : String = "petEatAction"
        var imageListArray: [UIImage] = []
        
        
        for countValue in 0..<2 {
            let strImageName: String = petImageNameDefault + String(countValue)
            let image = UIImage(named: strImageName)
            imageListArray.append(image!)
        }
        
        self.petImageView.animationImages = imageListArray
        self.petImageView.animationDuration = 1.0
        self.petImageView.animationRepeatCount = 3
        self.petImageView.startAnimating()
    }
    
    @IBAction func eatAction(_ sender: UIButton) {
        // have to insert status change function
        
        
        // change image looks like animation
        eatAnimation()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
