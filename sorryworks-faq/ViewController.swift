//
//  ViewController.swift
//  sorryworks-faq
//
//  Created by Todd Crone on 9/25/15.
//  Copyright © 2015 Bravo375. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
            let request = NSMutableURLRequest(URL: NSURL(string: "https://sorryworks-faq.herokuapp.com/faq")!)
        
            request.HTTPMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("EAD3757", forHTTPHeaderField: "x-catalog-token")
        
            let session = NSURLSession.sharedSession()
        
            let task = session.dataTaskWithRequest(request) {(data, response, error) in
                print("Response: \(response)")
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Body: \(strData)")
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    if let parseJSON = json {
                        // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                        print("Succes: \(parseJSON)")
                    }
                    else {
                        // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                        let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print("Error could not parse JSON: \(jsonStr)")
                    }
                }
                catch {
                        print("Failed parse")
                    }
                }
            task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    import UIKit
//    import XCPlayground
//    
//    XCPSetExecutionShouldContinueIndefinitely()
//    
//    var request = NSMutableURLRequest(URL: NSURL(string: "https://sorryworks-faq.herokuapp.com/faq")!)
//    
//    request.HTTPMethod = "GET"
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("application/json", forHTTPHeaderField: "Accept")
//    request.addValue("EAD3757", forHTTPHeaderField: "x-catalog-token")
//    
//    let session = NSURLSession.sharedSession()
//    
//    let task = session.dataTaskWithRequest(request) {(data, response, error) in
//        print(NSString(data: data!, encoding: NSUTF8StringEncoding))
//    }
//    
//    //let task = session.dataTaskWithURL(url!) {(data, response, error) in
//    //    print(NSString(data: data!, encoding: NSUTF8StringEncoding))
//    //}
//    
//    task.resume()
}

