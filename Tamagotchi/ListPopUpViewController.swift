//
//  ListPopUpViewController.swift
//  Tamagotchi
//
//  Created by user on 2017. 7. 23..
//  Copyright © 2017년 user. All rights reserved.
//

import UIKit

class ListPopUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    public var showEllement: [String: Int] = [:]
    public var tama: Tamagotchi?
    public var buttonListView1: UIView?
    public var buttonListView2: UIView?
    public var action: String?

    @IBOutlet weak var ellementTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        ellementTableView.delegate = self
        ellementTableView.dataSource = self
        // Do any additional setup after loading the view.
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showEllement.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ListPopUpTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListPopUpTableViewCell else { fatalError ( "The dequeued cell is not an instance of UserTableViewCell." ) }
        
        let key = Array(showEllement.keys)[indexPath.row]
        
        cell.ellementImageView.image = UIImage(named: key)
        cell.ellementNameLabel.text = key
        cell.ellementValueLabel.text = String(showEllement[key]!)
                
        return cell
    }

    
    // select table row func
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = Array(showEllement.values)[indexPath.row]
        self.view.removeFromSuperview()
        if (action == "eat") {
            tama!.updateHunger(delta: value * (-1))
        } else if (action == "play") {
            tama!.updateCloseness(delta: value * (-1))
        }
        
        // change image looks like animation
        tama!.animationStart(action: action!, view1: buttonListView1!, view2: buttonListView2!)   
    }
    
    
    
    @IBAction func closePopUp(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    
    

}
