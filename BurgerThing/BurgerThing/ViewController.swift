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
    
    // The current burger: an array of ingredients. Starts as an empty array.
    var currentBurgerIngredients : [String] = []
    
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
        self.currentBurgerIngredients.append(self.possibleIngredients[self.currentBurgerItem])
        
        // update the tableview
        let indexPath = NSIndexPath(forRow: self.currentBurgerIngredients.endIndex - 1, inSection: 0)
        self.tableview.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
    }
    @IBAction func orderBurger(sender: AnyObject) {
        
        self.burgerHandler.orderBurger(ingredients: self.currentBurgerIngredients) { (orderID, error) -> () in
            if let orderNumber = orderID
            {
                let alert = UIAlertController(title: "Burger Ordered", message: "You burger was successfully ordered, your order number is \(orderNumber)", preferredStyle: UIAlertControllerStyle.Alert)
                let dismissAction = UIAlertAction(title: "Got it", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(dismissAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else if error != nil
            {
                let alert = UIAlertController(title: "Order Failed", message: "Your order failed, \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                let dismissAction = UIAlertAction(title: "Bummer", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(dismissAction)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                // User cancelled; do nothing
            }
        }
    
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
        
        return self.currentBurgerIngredients.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("burgerIngredientCell") as UITableViewCell
        
        cell.textLabel?.text = self.currentBurgerIngredients[indexPath.row]
        
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
            self.currentBurgerIngredients.removeAtIndex(indexPath.row)
            
            // update the tableview
            self.tableview.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        
        }
    }

}

