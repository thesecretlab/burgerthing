//
//  BurgerHandler.swift
//  BurgerThing
//
//  Created by Timothy Rodney Nugent on 14/10/2014.
//  Copyright (c) 2014 Timothy Rodney Nugent. All rights reserved.
//

import UIKit

private let _sharedHandler = BurgerHandler()

let BurgerThingErrorDomain = "BurgerThingError"

typealias BurgerCompletionHandler = (orderID: String?, error:NSError?)->()

class BurgerHandler: NSObject {
    
    var baseBurger = ["Beef Patty","Mustard","Onion","Cheese","Pickles"]
    
    var baseURL = NSURL(string: "http://Normandy.local:8080")

    var testMode = false
    
    var newOrderURL : NSURL {
        get {
            return NSURL(string: "/orders/new", relativeToURL: self.baseURL)
        }
    }
    
    class var sharedHandler : BurgerHandler
    {
        return _sharedHandler
    }
    
    var ingredientsList : [String] {
        get {
            return [
                "Beef Patty",
                "Veg Patty",
                "Cheese",
                "Onions",
                "Jalapeños",
                "Bacon",
                "Beetroot",
                "Pickles",
                "Mustard",
                "Relish",
                "Gluten Free",
                "Side of Chips"
            ]
        }
    }
    
    func orderBurger(#ingredients:[String], completion:BurgerCompletionHandler)
    {
        
        let testString = self.testMode ? "[TEST MODE] " : ""
        
        let alert = UIAlertController(title: "Confirm Burger", message: "\(testString)Your burger is \(ingredients)", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
        { (action) -> Void in
            // do nothing really, I guess return a nil completion handler
            completion(orderID: nil, error: nil)
        }
        
        let orderAction = UIAlertAction(title: "Order Burger!", style: UIAlertActionStyle.Default)
        { (action) -> Void in
            
            if self.testMode == true {
                // If we're testing, immediately send back a success, but with a fake order number
                completion(orderID: "TEST", error: nil)
                return
            }
            
            self.sendOrder(ingredients: ingredients, completion: completion)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(orderAction)
        
        let window = UIApplication.sharedApplication().keyWindow
        window.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    func fallbackBurger()
    {
        // send an order to the server for a cheeseburger
        self.sendOrder(ingredients: self.baseBurger) { (orderID, error) -> () in
            if let orderNumber = orderID
            {
                let alert = UIAlertController(title: "Burger Ordered", message: "You burger was successfully ordered! Your order number is \(orderNumber)", preferredStyle: UIAlertControllerStyle.Alert)
                let dismissAction = UIAlertAction(title: "Got it", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(dismissAction)
                
                let window = UIApplication.sharedApplication().keyWindow
                window.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            }
            else if error != nil
            {
                let failureReason = error!.localizedFailureReason!
                
                let alert = UIAlertController(title: "Order Failed", message: "Your order failed! \(failureReason)", preferredStyle: UIAlertControllerStyle.Alert)
                let dismissAction = UIAlertAction(title: "Bummer", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(dismissAction)
                
                let window = UIApplication.sharedApplication().keyWindow
                window.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func sendOrder(#ingredients:[String],completion:BurgerCompletionHandler)
    {
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfiguration)
        
        let url = self.newOrderURL
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        let ingredients_list = ", ".join(ingredients)
        let data_string = "ingredients=\(ingredients_list)"
        
        request.HTTPBody = data_string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        let postTask = session.dataTaskWithRequest(request) { (data: NSData!, response : NSURLResponse!, error: NSError!) -> Void in
            
            // If there was an error communicating with the server, pass that error back
            if error != nil {
                completion(orderID: nil, error: error)
                return
            }
            
            // This should come back as an HTTP response
            
            if let HTTPResponse = response as? NSHTTPURLResponse {
                
                
                if HTTPResponse.statusCode == 200 {
                    
                    let orderIDString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    
                    completion(orderID: orderIDString, error: nil)
                    
                } else {

                    let errorString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    
                    let userInfo = [NSLocalizedDescriptionKey:"Error sending burger order",
                        NSLocalizedFailureReasonErrorKey:errorString,
                        NSLocalizedRecoverySuggestionErrorKey:"Have you considered turning it on and off again?"]
                    let error = NSError(domain: BurgerThingErrorDomain, code: 1, userInfo: userInfo)
                    completion(orderID: nil, error: error)
                    
                }
                
            } else {
                
                let userInfo = [NSLocalizedDescriptionKey:"Error contacting server",
                    NSLocalizedFailureReasonErrorKey:"Response was not an HTTP response!",
                    NSLocalizedRecoverySuggestionErrorKey:"Contact the admin!"]
                let error = NSError(domain: BurgerThingErrorDomain, code: 2, userInfo: userInfo)
                
                completion(orderID: nil, error: error)
                
            }
            
            
        }
        
        postTask.resume()
        
    }
   
}
