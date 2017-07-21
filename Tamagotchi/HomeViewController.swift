//
//  HomeViewController.swift
//  Tamagotchi
//
//  Created by user on 2017. 7. 20..
//  Copyright © 2017년 user. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //전체 펫 View
    @IBOutlet weak var petView: UIView!
    
    //button list view
    @IBOutlet weak var buttonListView1: UIView!
    @IBOutlet weak var buttonListView2: UIView!
    
    //tamacotchi buttons
    @IBOutlet weak var tamaButton1: UIButton!
    @IBOutlet weak var tamaButton2: UIButton!
    @IBOutlet weak var tamaButton3: UIButton!
    @IBOutlet weak var tamaButton4: UIButton!
    @IBOutlet weak var tamaButton5: UIButton!
    
    //status view
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusTableView: UITableView!
    // tamagotchi inforamtion
    var tamaInfo: [String] = ["이름: ", "나이: ", "배고픔: ", "청결도: ", "친밀도: "]
    
    
    //Tamagotchi
    var tama1: Tamagotchi?
    var tama2: Tamagotchi?
    var tama3: Tamagotchi?
    var tama4: Tamagotchi?
    var tama5: Tamagotchi?
    var selectedTama: Tamagotchi?
    
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make status view with default information
        statusTableView.delegate = self
        statusTableView.dataSource = self
        self.statusTableView?.tableFooterView = UIView()
        
        //initialize tamagotchi (load)
        tama1 = Tamagotchi(name: "tama", gender: "♂", button: tamaButton1)
        tama2 = Tamagotchi(name: "tata", gender: "♀", button: tamaButton2)
        tama3 = Tamagotchi(name: "tata", gender: "♀", button: tamaButton3)

        //tama3, tama4, tama5
    }

    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /***  Functions for click tamagotchi  ***/
    @IBAction func clickTama1(_ sender: UIButton) {
        selectedTama = tama1
    }
    @IBAction func clickTama2(_ sender: UIButton) {
        selectedTama = tama2
    }
    @IBAction func clickTama3(_ sender: UIButton) {
        selectedTama = tama3
    }
    @IBAction func clickTama4(_ sender: UIButton) {
        selectedTama = tama4
    }
    @IBAction func clickTama5(_ sender: UIButton) {
        selectedTama = tama5
    }
    
    
    /***  Functions for Action Buttons  ***/
    @IBAction func eatAction(_ sender: UIButton) {
        
        if let tama = selectedTama, !tama.isDoing {
            // have to insert status change function
            tama.hunger = tama.hunger - 10
            if(tama.hunger < 0){
                tama.hunger = 0
            }
            
            // change image looks like animation
            tama.animationStart(action: "eat", view1: buttonListView1, view2: buttonListView2)
        }
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        if let tama = selectedTama, (!tama.isDoing) {
            // have to insert status change function
            tama.closeness = tama.closeness + 10
        
            // change image looks like animation
            tama.animationStart(action: "play", view1: buttonListView1, view2: buttonListView2)
        }
    }

    @IBAction func washAction(_ sender: UIButton) {
        if let tama = selectedTama, !(tama.isDoing) {
            // have to insert status change function
            tama.cleanliness = tama.cleanliness + 10
            if tama.cleanliness > 100 {
                tama.cleanliness = 100
            }
            
            // change image looks like animation
            tama.animationStart(action: "wash", view1: buttonListView1, view2: buttonListView2)
        }
    }
    
    @IBAction func cleanAction(_ sender: UIButton) {
        // have to insert status change function
        
        // change image looks like animation
    }
    
    @IBAction func sleepAction(_ sender: UIButton) {
        if let tama = selectedTama, !(tama.isDoing) {
            // have to insert status change function
            tama.sleepiness = tama.sleepiness - 10
            if tama.sleepiness < 0 {
                tama.sleepiness = 0
            }
            
            // change image looks like animation
            tama.animationStart(action: "sleep", view1: buttonListView1, view2: buttonListView2)
        }
    }
    
    @IBAction func cureAction(_ sender: UIButton) {
        if let tama = selectedTama, !(tama.isDoing) {
            // have to insert status change function
            tama.health = tama.health + 50
            if tama.health > 100 {
                tama.health = 100
            }
            
            // change image looks like animation
            tama.animationStart(action: "wash", view1: buttonListView1, view2: buttonListView2)
        }
    }
    
    @IBAction func loveAction(_ sender: UIButton) {
    }
    
    @IBAction func statusView(_ sender: UIButton) {
        if let tama = selectedTama, !(tama.isDoing) {
            //view status
            tamaInfo = tama.getInfo()
            statusTableView.reloadData()
            
            statusView.isHidden = false
        }
    }
    
    
    /*** functions for status view ***/
    @IBAction func statusCloseButton(_ sender: UIButton) {
        statusView.isHidden = true
    }
    
    //return number of rows in tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tamaInfo.count
    }
    
    //Choose your custom row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 29.0;
    }
    
    //load tableview cell data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 10.0)
        cell.textLabel?.text = tamaInfo[indexPath.row]
        return cell
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
