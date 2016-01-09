//
//  BonjourServiceTableViewController.swift
//  Network Browser
//
//  Created by Thomas Petz, Jr. on 12/29/15.
//  Copyright © 2015 Thomas J. Petz, Jr. All rights reserved.
//

import UIKit

class BonjourServiceTableViewController: UITableViewController, NSNetServiceBrowserDelegate {

    // MARK: Properties
    let myBonjourServiceBrowser = NSNetServiceBrowser()  // Bonjour Service Browser
    var foundServices: [String] = []                     // Just a quick place to store the service descriptions we get back.
    var services: [NSNetService] = []                    // Array to save the services we discover
    let serviceQuery = "_services._dns-sd._udp."          // Service name to query the network for available services
    var domain: String = ""                             // Domain to search, by default use empty string which implies .local

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        myBonjourServiceBrowser.delegate = self
        
        // Look for services.
        print("starting search for available services") //  - \(wellKnownServices[currentServiceIndex])")
        myBonjourServiceBrowser.searchForServicesOfType(serviceQuery, inDomain: domain)

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
        return foundServices.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BonjourServiceTableViewCell", forIndexPath: indexPath) as! BonjourServiceTableViewCell

        // Configure the cell...
        cell.serviceName.text = services[indexPath.row].name + "." + services[indexPath.row].type
        
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
        let serviceView = segue.destinationViewController as! DiscoveredServicesTableViewController
        
        myBonjourServiceBrowser.stop()      // halt any running searches before moving to the detail
        
        // Get the cell that generated this segue.
        if let selectedCell = sender as? BonjourServiceTableViewCell {
            let indexPath = tableView.indexPathForCell(selectedCell)!
            let selectedService = services[indexPath.row]
            serviceView.serviceName = selectedService.name
            serviceView.serviceType = selectedService.type
        }
    }

    override func viewWillDisappear(animated: Bool) {
        // before the view disappears stop any browsers.
        myBonjourServiceBrowser.stop()
    }

    // MARK: Delegate callbacks
    
    func netServiceBrowserWillSearch(browser: NSNetServiceBrowser) {
        print("Starting to search services")
    }
    
    // Called for each service search
    func netServiceBrowser(browser: NSNetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print("Did not search for services")
    }
    
    // Called for each service found
    func netServiceBrowser(browser: NSNetServiceBrowser, didFindService service: NSNetService, moreComing: Bool) {

        let newIndexPath = NSIndexPath(forRow: foundServices.count, inSection: 0)
        
        foundServices += [service.name]
        services += [service]

        print("Found service - \(service.description)")
        
        tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        
    }
    
    func netServiceBrowserDidStopSearch(browser: NSNetServiceBrowser) {
        // The search has stopped for the current search.  If we have more searches to perform then start them.
        print("Got stop")
    }

}
