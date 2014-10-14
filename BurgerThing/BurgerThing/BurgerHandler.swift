//
//  BurgerHandler.swift
//  BurgerThing
//
//  Created by Timothy Rodney Nugent on 14/10/2014.
//  Copyright (c) 2014 Timothy Rodney Nugent. All rights reserved.
//

import UIKit

private let _sharedHandler = BurgerHandler()

class BurgerHandler: NSObject {
    
    var serverWorked:Bool = true
    
    class var sharedHandler : BurgerHandler
    {
        return _sharedHandler
    }
    
    func orderBurger(#ingredients:[String], completion:(error:NSError?)->())
    {
        let alert = UIAlertController(title: "Confirm Burger", message: "Your burger is \(ingredients)", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel Burger", style: UIAlertActionStyle.Cancel)
        { (action) -> Void in
            // do nothing really, I guess return a nil completion handler
            completion(error: nil)
        }
        
        let orderAction = UIAlertAction(title: "Order Burger!", style: UIAlertActionStyle.Default)
        { (action) -> Void in
            // send the order off to the server
            if self.serverWorked
            {
                completion(error: nil)
            }
            else
            {
                self.sendOrder(ingredients: ingredients, completion: completion)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(orderAction)
        
        let window = UIApplication.sharedApplication().keyWindow
        window.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    func ingredientsList()->[String]
    {
        return ["Meat","Cheese","Tomato","Jalapeño","Other stuff"]
    }
    func fallbackBurger(completion:(error:NSError?)->())
    {
        // send an order to the server for a cheeseburger
        self.sendOrder(ingredients: ["Cheese","Meat","Onions"], completion: completion)
    }
    
    private func sendOrder(#ingredients:[String],completion:(error:NSError?)->())
    {
        // actually do the server stuff here
        if self.serverWorked
        {
            completion(error: nil)
        }
        else
        {
            let userInfo = [NSLocalizedDescriptionKey:"Something went wrong sending the burger order",
                NSLocalizedFailureReasonErrorKey:"Totally blame the WiFi",
                NSLocalizedRecoverySuggestionErrorKey:"Have you considered turning it on and off again?"]
            let error = NSError(domain: "Server Issue", code: 1, userInfo: userInfo)
            completion(error: error)
        }
    }
   
}
