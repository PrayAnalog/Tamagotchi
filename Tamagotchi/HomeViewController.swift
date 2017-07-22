//
//  HomeViewController.swift
//  Tamagotchi
//
//  Created by user on 2017. 7. 20..
//  Copyright © 2017년 user. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var statusTimer: Timer!
    var dungTimer: Timer!
    var count = 0
    var dungImage = UIImage(named: "dung")
    var dungList: [UIImageView] = []
    let dungMakeTime: Float = 20
    
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
    
    //status Lables
    @IBOutlet weak var nameT: UILabel!
    @IBOutlet weak var ageT: UILabel!
    @IBOutlet weak var hungerT: UILabel!
    @IBOutlet weak var cleanlinessT: UILabel!
    @IBOutlet weak var closenessT: UILabel!
    var statusLabels: [UILabel]?
    
    @IBOutlet weak var ageP: UIProgressView!
    @IBOutlet weak var hungerP: UIProgressView!
    @IBOutlet weak var cleanlinessP: UIProgressView!
    var statusProgs: [UIProgressView]?
    
    
    //status view
    @IBOutlet weak var statusView: UIView!
    
    // tamagotchi inforamtion
    var tamaInfo: [String] = ["", "0", "0", "0", "0"]
    
    
    //Tamagotchi
    var tama1: Tamagotchi?
    var tama2: Tamagotchi?
    var tama3: Tamagotchi?
    var tama4: Tamagotchi?
    var tama5: Tamagotchi?
    var selectedTama: Tamagotchi?
    var tamas: [Tamagotchi]?
    
    //Max status
    let maxValue: Float = 100
    
    public let dataFileName: String = "Tamagotchi.json"

    
    /*** Do any additional setup after loading the view. ***/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleTamagotchiData()
        statusLabels = [nameT, ageT, hungerT, cleanlinessT, closenessT]
        statusProgs = [ageP, hungerP, cleanlinessP]
        //필요해서 만들었어요! 고쳐주세요
        tamas = [tama1!, tama2!, tama3!]
        for i in 0..<tamas!.count {
            AutomaticStatusChange(tama: tamas![i])
        }
        AutomaticMakeDung()
//        loadTamagotchiData()
    }
    
    
    func loadSampleTamagotchiData() {
        tama1 = Tamagotchi(name: "tama", gender: "♂", button: tamaButton1)
        tama2 = Tamagotchi(name: "tata", gender: "♀", button: tamaButton2)
        tama3 = Tamagotchi(name: "tata", gender: "♀", button: tamaButton3)
        //tama3, tama4, tama5
    }
 

    func saveTamagotchiData() {
        // Get the url of Persons.json in document directory
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent(dataFileName)
        
        var tamagotchiArray: [Any] = []
        
        if (tama1 != nil) {
            tamagotchiArray.append(tama1!.getData())
        }
        if (tama2 != nil) {
            tamagotchiArray.append(tama2!.getData())
        }
        if (tama3 != nil) {
            tamagotchiArray.append(tama3!.getData())
        }
        if (tama4 != nil) {
            tamagotchiArray.append(tama4!.getData())
        }
        if (tama5 != nil) {
            tamagotchiArray.append(tama5!.getData())
        }
        
        // Transform array into data and save it into file
        do {
            let data = try JSONSerialization.data(withJSONObject: tamagotchiArray, options: [])
            try data.write(to: fileUrl, options: [])
            print("saveTamagotchiData finish")
        } catch {
            print(error)
        }
    }
    
    
    func loadTamagotchiData() {
        // Get the url of Persons.json in document directory
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent(dataFileName)
        
        // Read data from .json file and transform data into an array
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let tamagotchiArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] else { return }
            
            for item in tamagotchiArray {
                print(item)
                if (tama1 == nil) {
                    tama1 = Tamagotchi(name: item["name"] as! String, gender: item["gender"] as! String, button: tamaButton1, age: item["age"] as! Int, hunger: item["hunger"] as! Int, cleanliness: item["cleanliness"] as! Int, closeness: item["closeness"] as! Int, health: item["health"] as! Int, sleepiness: item["sleepiness"] as! Int, species: item["species"] as! String, isDoing: false)
                }
                else if (tama2 == nil) {
                    tama1 = Tamagotchi(name: item["name"] as! String, gender: item["gender"] as! String, button: tamaButton2, age: item["age"] as! Int, hunger: item["hunger"] as! Int, cleanliness: item["cleanliness"] as! Int, closeness: item["closeness"] as! Int, health: item["health"] as! Int, sleepiness: item["sleepiness"] as! Int, species: item["species"] as! String, isDoing: false)
                }
                else if (tama3 == nil) {
                    tama1 = Tamagotchi(name: item["name"] as! String, gender: item["gender"] as! String, button: tamaButton3, age: item["age"] as! Int, hunger: item["hunger"] as! Int, cleanliness: item["cleanliness"] as! Int, closeness: item["closeness"] as! Int, health: item["health"] as! Int, sleepiness: item["sleepiness"] as! Int, species: item["species"] as! String, isDoing: false)
                }
                else if (tama4 == nil) {
                    tama1 = Tamagotchi(name: item["name"] as! String, gender: item["gender"] as! String, button: tamaButton4, age: item["age"] as! Int, hunger: item["hunger"] as! Int, cleanliness: item["cleanliness"] as! Int, closeness: item["closeness"] as! Int, health: item["health"] as! Int, sleepiness: item["sleepiness"] as! Int, species: item["species"] as! String, isDoing: false)
                }
                else if (tama5 == nil) {
                    tama1 = Tamagotchi(name: item["name"] as! String, gender: item["gender"] as! String, button: tamaButton5, age: item["age"] as! Int, hunger: item["hunger"] as! Int, cleanliness: item["cleanliness"] as! Int, closeness: item["closeness"] as! Int, health: item["health"] as! Int, sleepiness: item["sleepiness"] as! Int, species: item["species"] as! String, isDoing: false)
                }
            }
        } catch {
            print(error)
            // if first app loading, there will be not dataFile
            // so have to make a baby tama random name and gender, and save the data
            
            // have to change here
            tama1 = Tamagotchi(name: "tama", gender: "♂", button: tamaButton1)
            saveTamagotchiData()
        }
    }
    
    
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

    /***  Change status as the time passed  ***/
    func AutomaticStatusChange (tama: Tamagotchi){
        statusTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {_ in
            tama.updateAge(delta: 1)
            tama.updateHunger(delta: 1)
            tama.updateCleanliness(delta: -1)
            tama.updateCloseness(delta: -1)
        })
    }
    
    func AutomaticMakeDung () {
        dungTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(dungMakeTime / Float(tamas!.count)), repeats: true, block: {_ in
            let randomSize = arc4random_uniform(15) + 30
            let randomX = arc4random_uniform(300)
            let randomY = arc4random_uniform(250)
            
            let dungImageView = UIImageView(frame: self.CGRectMake(CGFloat(randomX), CGFloat(randomY), CGFloat(randomSize), CGFloat(randomSize)))
            dungImageView.image = self.dungImage!
            dungImageView.backgroundColor = UIColor.clear
            
            self.dungList.append(dungImageView)
            self.petView.addSubview(dungImageView)
            self.petView.sendSubview(toBack: dungImageView)
        })
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    
    /***  Functions for click tamagotchi  ***/
    @IBAction func clickTama1(_ sender: UIButton) {
        if let tama = tama1 {
            clickTamaButton(tama: tama)
        }
    }
    @IBAction func clickTama2(_ sender: UIButton) {
        if let tama = tama2 {
            clickTamaButton(tama: tama)
        }
    }
    @IBAction func clickTama3(_ sender: UIButton) {
        if let tama = tama3 {
            clickTamaButton(tama: tama)
        }
    }
    @IBAction func clickTama4(_ sender: UIButton) {
        if let tama = tama4 {
            clickTamaButton(tama: tama)
        }
    }
    @IBAction func clickTama5(_ sender: UIButton) {
        if let tama = tama5 {
            clickTamaButton(tama: tama)
        }
    }
    
    @IBAction func clickOffTama(_ sender: UIButton) {
        tamaButtonReset()
        selectedTama = nil
    }
    
    func clickTamaButton(tama: Tamagotchi) {
        selectedTama = tama
        tamaButtonReset()
        selectedTama!.isSelected = true
        selectedTama!.setBackground()
        if tama.isDoing == false {
            buttonListView1.alpha = 1
            buttonListView2.alpha = 1
        }else {
            buttonListView1.alpha = 0.6
            buttonListView2.alpha = 0.6
        }
    }
    
    func tamaButtonReset() {
        for i in 0..<tamas!.count {
            tamas?[i].isSelected = false
            tamas?[i].setBackground()
        }
    }
    
    
    
    
    /***  Functions for Action Buttons  ***/
    @IBAction func eatAction(_ sender: UIButton) {
        
        if let tama = selectedTama, !tama.isDoing {
            // have to insert status change function
            tama.updateHunger(delta: -10)
            
            // change image looks like animation
            tama.animationStart(action: "eat", view1: buttonListView1, view2: buttonListView2)
        }
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        if let tama = selectedTama, (!tama.isDoing) {
            // have to insert status change function
            tama.updateCloseness(delta: 10)
            // change image looks like animation
            tama.animationStart(action: "play", view1: buttonListView1, view2: buttonListView2)
        }
    }

    @IBAction func washAction(_ sender: UIButton) {
        if let tama = selectedTama, !(tama.isDoing) {
            // have to insert status change function
            tama.updateCleanliness(delta: 10)
            
            // change image looks like animation
            tama.animationStart(action: "wash", view1: buttonListView1, view2: buttonListView2)
        }
    }
    
    @IBAction func cleanAction(_ sender: UIButton) {
        for i in 0..<dungList.count {
            dungList[i].removeFromSuperview()
        }
    }
    
    @IBAction func sleepAction(_ sender: UIButton) {
        if let tama = selectedTama, !(tama.isDoing) {
            // have to insert status change function
            tama.updateSleepiness(delta: -10)
            
            // change image looks like animation
            tama.animationStart(action: "sleep", view1: buttonListView1, view2: buttonListView2)
        }
    }
    
    @IBAction func cureAction(_ sender: UIButton) {
        if let tama = selectedTama, !(tama.isDoing) {
            // have to insert status change function
            tama.updateHealth(delta: 50)
            
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
            for i in 0..<tamaInfo.count{
                statusLabels?[i].text = tamaInfo[i]
                if (i-1 >= 0 && i-1 < 3){
                    if let value: Int = Int(tamaInfo[i]) {
                        statusProgs?[i-1].transform = CGAffineTransform(scaleX: 1, y: 4);
                        statusProgs?[i-1].progress = Float(value) / maxValue
                    }
                }
            }
            statusView.isHidden = false
        }
    }
    
    
    /*** functions for status view ***/
    @IBAction func statusCloseButton(_ sender: UIButton) {
        statusView.isHidden = true
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
