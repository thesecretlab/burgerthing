//
//  ViewController.swift
//  BurgerThing
//
//  Created by Timothy Rodney Nugent on 14/10/2014.
//  Copyright (c) 2014 Timothy Rodney Nugent. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var burgerItem: UILabel!
    var currentBurgerItem : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func previousItem(sender: AnyObject) {
        // move onto the previous item in the list of burger items
    }
    @IBAction func nextItem(sender: AnyObject) {
        // move onto the next item in the list of burger items
    }
    @IBAction func addBurgerItem(sender: AnyObject) {
        // add the current burger Item into the array of burger Items
    }

}

