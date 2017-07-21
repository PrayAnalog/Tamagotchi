//
//  HomeViewController.swift
//  Tamagotchi
//
//  Created by user on 2017. 7. 20..
//  Copyright © 2017년 user. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var petView: UIView! //전체 펫 View
    
    @IBOutlet weak var pet1: UIButton!
    @IBOutlet weak var pet2: UIButton!
    @IBOutlet weak var pet3: UIButton!
    @IBOutlet weak var pet4: UIButton!
    @IBOutlet weak var pet5: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func eatAction(_ sender: UIButton) {
        // have to insert status change function
        
        
        // change image looks like animation
        let newPet = Tamagotchi(name: "tama", gender: "♂", button: pet1)
        newPet?.animationStart(action: "")
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
