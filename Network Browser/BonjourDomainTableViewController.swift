//
//  BonjourDomainTableViewController.swift
//  Network Browser
//
//  Created by Thomas Petz, Jr. on 12/24/15.
//  Copyright © 2015 Thomas J. Petz, Jr. All rights reserved.
//

import Foundation
import UIKit

class BonjourDomainTableViewController: UITableViewController, NSNetServiceBrowserDelegate {

    // MARK: Properties
    let myBonjourDomainBrowser = NSNetServiceBrowser()
    var foundDomains: [String] = []                     // An array of the browsable domains this device can reach
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        myBonjourDomainBrowser.delegate = self
        
        // Look for domains.
        myBonjourDomainBrowser.searchForRegistrationDomains()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundDomains.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "BonjourDomainTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! BonjourDomainTableViewCell

        // Configure the cell...

        cell.domain.text = foundDomains[indexPath.row]
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let searchDetailTableView = segue.destinationViewController as! BonjourServiceTableViewController
        
        myBonjourDomainBrowser.stop()   // stop any running searches
        
        // Get the cell that generated this segue.
        if let selectedMealCell = sender as? BonjourDomainTableViewCell {
            let indexPath = tableView.indexPathForCell(selectedMealCell)!
            let selectedDomain = foundDomains[indexPath.row]
            searchDetailTableView.domain = selectedDomain
        }
    
    }

    // MARK: Delegate callbacks

    // Called when we search for browsable domains
    func netServiceBrowser(browser: NSNetServiceBrowser, didFindDomain domainString: String, moreComing: Bool) {
        let newIndexPath = NSIndexPath(forRow: foundDomains.count, inSection: 0)
        foundDomains += [domainString]

        tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        
        if !moreComing {
            browser.stop()
        }
    }
    
    func netServiceBrowserWillSearch(browser: NSNetServiceBrowser) {
        print("Starting to search domains")
    }
    
    // Called for each service search
    func netServiceBrowser(browser: NSNetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print("Did not search for domains")
    }
    
}
