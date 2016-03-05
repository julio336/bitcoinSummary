//
//  ViewController.swift
//  bitcoinSummary
//
//  Created by Julio Ahuactzin on 04/03/16.
//  Copyright © 2016 Julio Ahuactzin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var lastTradeLabel: UILabel!
    
    @IBOutlet weak var maxTradeLabel: UILabel!
    
    @IBOutlet weak var minTradeLabel: UILabel!
    
    
    @IBOutlet weak var lastTradeCoinDeskLabel: UILabel!
    
    @IBOutlet weak var maxTradeCoinDeskLabel: UILabel!
    
    @IBOutlet weak var minTradeCoinDeskLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func updateButton() {
        self.lastTradeLabel.text = "-"
        self.maxTradeLabel.text = "-"
        self.minTradeLabel.text = "-"
        
        self.lastTradeCoinDeskLabel.text = "-"
        self.maxTradeCoinDeskLabel.text = "-"
        self.minTradeCoinDeskLabel.text = "-"
        
        //************************** Task for Bitso API **************************************************
        let urlBitso = NSURL(string: "https://api.bitso.com/v2/ticker")
        let sessionBitso = NSURLSession.sharedSession()
        let task = sessionBitso.dataTaskWithURL(urlBitso!, completionHandler:{data, response, error -> Void in
            
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers)
                guard let JSONDictionary :NSDictionary = JSON as? NSDictionary else {
                    print("Not a Dictionary")
                    // put in function
                    return
                }
                
                print("JSONDictionary! \(JSONDictionary)")
                dispatch_async(dispatch_get_main_queue()) {
                    let priceHigh = JSONDictionary["high"] as! String
                    let high = ("$\(priceHigh) MXN")
                    self.maxTradeLabel.text = high
                    let priceLow = JSONDictionary["low"] as! String
                    let low = ("$\(priceLow) MXN")
                    self.minTradeLabel.text = low
                    let priceLast = JSONDictionary["last"] as! String
                    let last = ("$\(priceLast) MXN")
                    self.lastTradeLabel.text = last
                    self.dismissViewControllerAnimated(false, completion: nil)

                }
            }
            catch let JSONError as NSError {
                print("\(JSONError)")
            }
            
        })
        task.resume()
        //**************************************************************************************************
        //**************************** Task for CoinDesk API ***********************************************
        let urlCoinDesk = NSURL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")
        let sessionCoinDesk = NSURLSession.sharedSession()
        let taskCoinDesk = sessionCoinDesk.dataTaskWithURL(urlCoinDesk!, completionHandler:{data, response, error -> Void in
            
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers)
                guard let JSONDictionary :NSDictionary = JSON as? NSDictionary else {
                    print("Not a Dictionary")
                    // put in function
                    return
                }
                
                //print("JSONDictionary! \(JSONDictionary["bpi"]!["USD"]!!["rate"])")
                dispatch_async(dispatch_get_main_queue()) {
                    let priceLastCoinDesk = JSONDictionary["bpi"]!["USD"]!!["rate"] as! String
                    let temp = Float(priceLastCoinDesk)
                    let temp2 = String(format:"%.2f", temp!)
                    print(temp2)
                    let last = "\(temp2) USD"
                    self.lastTradeCoinDeskLabel.text = last

                }
            }
            catch let JSONError as NSError {
                print("\(JSONError)")
            }
            
        })
        taskCoinDesk.resume()

        
        
        //adding a loading alert
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .Alert)
        
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        self.presentViewController(alert, animated: true, completion: nil)
        
        ///////////////////////
        
            
        
        
    }// end IBAction
    

    


}

