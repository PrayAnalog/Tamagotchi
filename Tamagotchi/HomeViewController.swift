//
//  HomeViewController.swift
//  Tamagotchi
//
//  Created by user on 2017. 7. 20..
//  Copyright © 2017년 user. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var petView: UIView! //전체 펫 View
    
    @IBOutlet weak var pet1: UIButton!
    @IBOutlet weak var pet2: UIButton!
    @IBOutlet weak var pet3: UIButton!
    @IBOutlet weak var pet4: UIButton!
    @IBOutlet weak var pet5: UIButton!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusTableView: UITableView!
    
    var tama1: Tamagotchi?
    
    var tamaInfo: [String]? = ["이름: ", "나이: ", "배고픔: ", "청결도: ", "친밀도: "]  // tamagotchi inforamtion
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusTableView.delegate = self
        statusTableView.dataSource = self
        self.statusTableView?.tableFooterView = UIView()
        
        tama1 = Tamagotchi(name: "tama", gender: "♂", button: pet1)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func eatAction(_ sender: UIButton) {
        //get pet object
        
        // have to insert status change function
        tama1!.hunger = tama1!.hunger - 10
        
        // change image looks like animation
        tama1!.animationStart(action: "eat")
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        //get pet object
        
        // have to insert status change function
        tama1!.closeness = tama1!.closeness + 10
        
        // change image looks like animation
        tama1!.animationStart(action: "play")
    }

    @IBAction func washAction(_ sender: UIButton) {
        //get pet object
        
        // have to insert status change function
        tama1!.cleanliness = tama1!.closeness + 10
        
        // change image looks like animation
        tama1!.animationStart(action: "wash")
    }
    
    @IBAction func cleanAction(_ sender: UIButton) {
        //get pet object
        
        // have to insert status change function
        
        // change image looks like animation
    }
    
    @IBAction func sleepAction(_ sender: UIButton) {
        //get pet object
        
        // have to insert status change function
        tama1!.sleepiness = tama1!.sleepiness - 10
        
        // change image looks like animation
        tama1!.animationStart(action: "sleep")
    }
    
    @IBAction func cureAction(_ sender: UIButton) {
        //get pet object
        
        // have to insert status change function
        tama1!.health = tama1!.sleepiness + 50
        
        // change image looks like animation
        tama1!.animationStart(action: "wash")
    }
    
    @IBAction func loveAction(_ sender: UIButton) {
    }
    
    @IBAction func statusView(_ sender: UIButton) {
        //get pet object
        
        //view status
        tamaInfo = tama1!.getInfo()
        statusTableView.reloadData()
        
        statusView.isHidden = false
    }
    
    @IBAction func statusCloseButton(_ sender: UIButton) {
        statusView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tamaInfo!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 29.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        if let info = tamaInfo {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 10.0)
            cell.textLabel?.text = info[indexPath.row]
        }
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
