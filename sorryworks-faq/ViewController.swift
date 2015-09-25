//
//  ViewController.swift
//  sorryworks-faq
//
//  Created by Todd Crone on 9/25/15.
//  Copyright © 2015 Bravo375. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var faqs: Array <Faq> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadFaqs()

        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: "handleRefresh:",
            forControlEvents: UIControlEvents.ValueChanged)
        refreshControl = refresher
    }

    @IBAction func handleRefresh(sender : AnyObject) {
        reloadFaqs()
        refreshControl!.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func reloadFaqs() {
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
                let json: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
                self.faqs.removeAll(keepCapacity: true)
                if let jsonArray = json as? [[String:AnyObject]] {
                    for faqDict in jsonArray {
                        let faq = Faq()
                        faq.question = faqDict["question"] as? String
                        faq.answer = NSURL(string: faqDict["answer"] as! String)!
                        print(faq.question)
                        self.faqs.append(faq)
                        print(self.faqs.count)
                    }
                    print("Reloading data")
                    self.tableView.reloadData()
                    print("Done reloading data")
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows \(faqs.count)")
        return faqs.count
    }

    override func tableView (_tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        let faq = faqs[indexPath.row]
        cell.textLabel?.text = faq.question
        return cell
    }
}
