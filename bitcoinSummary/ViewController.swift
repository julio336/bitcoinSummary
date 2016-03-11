//
//  ViewController.swift
//  bitcoinSummary
//
//  Created by Julio Ahuactzin on 04/03/16.
//  Copyright © 2016 Julio Ahuactzin. All rights reserved.
//

import UIKit

var btc:Float = 0.00

class ViewController: UIViewController {
    
    
    @IBOutlet weak var lastTradeLabel: UILabel!
    
    @IBOutlet weak var maxTradeLabel: UILabel!
    
    @IBOutlet weak var minTradeLabel: UILabel!
    
    @IBOutlet weak var lastTradeCoinDeskLabel: UILabel!
    
    @IBOutlet weak var maxTradeCoinDeskLabel: UILabel!
    
    @IBOutlet weak var minTradeCoinDeskLabel: UILabel!
    
    @IBOutlet weak var usdMxnLabel: UILabel!
    
    @IBOutlet weak var mxnBtcLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //******************************* Task for get the Btc currentPrice *********************************
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
                    btc = Float(priceLastCoinDesk)!
                    print(btc)
                }
            }
            catch let JSONError as NSError {
                print("\(JSONError)")
            }
            
        })
        taskCoinDesk.resume()// End of task
        
        
        //************************************* Task for scrape the Btc change rate ******************************
       /* let url = NSURL(string: "https://www.coindesk.com/price")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if error != nil{
                dispatch_async(dispatch_get_main_queue()) {
                    let urlContent = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print(urlContent)
                }
            }else{
                print("Error loading")
                
            }
        })
        task.resume()*/

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
                    let last = "\(temp2) USD"
                    self.lastTradeCoinDeskLabel.text = last

                }
            }
            catch let JSONError as NSError {
                print("\(JSONError)")
            }
            
        })
        taskCoinDesk.resume()

        //******************************* Task for exchange ********************************************************
        
        let urlExchange = NSURL(string: "http://apilayer.net/api/live?access_key=f6b79d043067c022b04be22e6ca2e83f&currencies=USD,MXN&format=1")
        let sessionExchange = NSURLSession.sharedSession()
        let taskExchange = sessionExchange.dataTaskWithURL(urlExchange!, completionHandler:{data, response, error -> Void in
            
            
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers)
                guard let JSONDictionary :NSDictionary = JSON as? NSDictionary else {
                    print("Not a Dictionary")
                    // put in function
                    return
                }
                
                
               // print("JSONDictionary! \(JSONDictionary["quotes"]!["USDMXN"])")
                dispatch_async(dispatch_get_main_queue()) {
                    let priceExchange = JSONDictionary["quotes"]!["USDMXN"] as! NSNumber
                    let temp = String(format:"%.2f", Float(priceExchange))
                    let last = "$\(temp) MXN"
                    self.usdMxnLabel.text = last
                    let temp2 = String(format:"%.2f", Float(Float(priceExchange)*btc))
                    self.mxnBtcLabel.text = "$\(temp2) MXN"
                }
            }
            catch let JSONError as NSError {
                print("\(JSONError)")
            }
            
        })
        taskExchange.resume()
        //***************************************************************************************************************
        
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

