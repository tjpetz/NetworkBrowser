//
//  DiscoveredServicesTableViewController.swift
//  Network Browser
//
//  For a specified service discover all providers.
//
//  Created by Thomas Petz, Jr. on 1/9/16.
//  Copyright © 2016 Thomas J. Petz, Jr. All rights reserved.
//

import UIKit

class DiscoveredServicesTableViewController: UITableViewController, NSNetServiceBrowserDelegate {

    // MARK: Properties
    
    var domain: String = ""
    var serviceName: String = ""
    var serviceType: String = ""
    var services: [NSNetService] = []                    // Array to save the services we discover
    var foundServices: [String] = []                     // array of found service names
    let myBonjourServiceBrowser = NSNetServiceBrowser()  // Bonjour Service Browser
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
     
        // The serviceType we receive includes the domain.  We need to
        // extract the type without the domain name.
        let browseForService = serviceName + "." + serviceType.substringToIndex((serviceType.rangeOfString(".")?.startIndex)!)
        
        print("Search for service - \(browseForService)")
        myBonjourServiceBrowser.delegate = self
        myBonjourServiceBrowser.searchForServicesOfType(browseForService, inDomain: domain)
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("DiscoveredServiceTableCell", forIndexPath: indexPath) as! DiscoveredServiceTableViewCell
        
        // Configure the cell...
        cell.serviceName.text = services[indexPath.row].name
        
        return cell
    }

    override func viewWillDisappear(animated: Bool) {
        // before the view disappears stop any browsers.
        myBonjourServiceBrowser.stop()
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
        let serviceView = segue.destinationViewController as! ServiceDetailViewController
        
        myBonjourServiceBrowser.stop()      // halt any running searches before moving to the detail
        
        // Get the cell that generated this segue.
        if let selectedCell = sender as? DiscoveredServiceTableViewCell {
            let indexPath = tableView.indexPathForCell(selectedCell)!
            let selectedService = services[indexPath.row]
            serviceView.service = selectedService
        }
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
        
        foundServices += [service.description]
        services += [service]
        
        print("Found service - \(service.description)")
        
        tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        
    }
    
    func netServiceBrowserDidStopSearch(browser: NSNetServiceBrowser) {
        // The search has stopped for the current search.  If we have more searches to perform then start them.
        print("Got stop")
    }
    

}
