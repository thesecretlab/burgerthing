//
//  ViewController.swift
//  BurgerThing
//
//  Created by Timothy Rodney Nugent on 14/10/2014.
//  Copyright (c) 2014 Timothy Rodney Nugent. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var burgerItemLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!

    var currentBurgerItem : Int = 0
    let burgerHandler = BurgerHandler.sharedHandler
    let possibleIngredients = BurgerHandler.sharedHandler.ingredientsList()
    var myBurger : [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.updateBurgerItemLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func previousItem(sender: AnyObject) {
        // move onto the previous item in the list of burger items
        self.currentBurgerItem--
        self.currentBurgerItem = self.currentBurgerItem % self.possibleIngredients.count
        self.updateBurgerItemLabel()
    }
    @IBAction func nextItem(sender: AnyObject) {
        // move onto the next item in the list of burger items
        self.currentBurgerItem++
        self.currentBurgerItem = self.currentBurgerItem % self.possibleIngredients.count
        self.updateBurgerItemLabel()
    }
    @IBAction func addBurgerItem(sender: AnyObject) {
        // add the current burger Item into the array of burger Items
        if (self.myBurger != nil)
        {
            self.myBurger?.append(self.possibleIngredients[self.currentBurgerItem])
        }
        else
        {
            self.myBurger = [self.possibleIngredients[self.currentBurgerItem]]
        }
        
        // update the tableview
        let indexPath = NSIndexPath(forRow: self.myBurger!.endIndex - 1, inSection: 0)
        self.tableview.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
    }
    
    func updateBurgerItemLabel()
    {
        self.burgerItemLabel.text = self.possibleIngredients[self.currentBurgerItem]
    }
    
    //MARK: tableview datasource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let theBurger = self.myBurger
        {
            return theBurger.count
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("burgerIngredientCell") as UITableViewCell
        
        if let theBurger = self.myBurger
        {
            cell.textLabel?.text = theBurger[indexPath.row]
        }
        
        return cell
    }
    
    //MARK: tableview delegate methods
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            // remove the item from the array
            if (self.myBurger != nil)
            {
                self.myBurger?.removeAtIndex(indexPath.row)
                
                // update the tableview
                self.tableview.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
            }
        }
    }

}

