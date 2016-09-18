//
//  BonjourServiceTableViewController.swift
//  Network Browser
//
//  Created by Thomas Petz, Jr. on 12/29/15.
//  Copyright © 2015 Thomas J. Petz, Jr. All rights reserved.
//

import UIKit

class BonjourServiceTableViewController: UITableViewController, NetServiceBrowserDelegate {

    // MARK: Properties
    let myBonjourServiceBrowser = NetServiceBrowser()  // Bonjour Service Browser
    var foundServices: [String] = []                     // Just a quick place to store the service descriptions we get back.
    var services: [NetService] = []                    // Array to save the services we discover
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
        myBonjourServiceBrowser.searchForServices(ofType: serviceQuery, inDomain: domain)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundServices.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BonjourServiceTableViewCell", for: indexPath) as! BonjourServiceTableViewCell

        // Configure the cell...
        cell.serviceName.text = services[(indexPath as NSIndexPath).row].name + "." + services[(indexPath as NSIndexPath).row].type
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let serviceView = segue.destination as! DiscoveredServicesTableViewController
        
        myBonjourServiceBrowser.stop()      // halt any running searches before moving to the detail
        
        // Get the cell that generated this segue.
        if let selectedCell = sender as? BonjourServiceTableViewCell {
            let indexPath = tableView.indexPath(for: selectedCell)!
            let selectedService = services[(indexPath as NSIndexPath).row]
            serviceView.serviceName = selectedService.name
            serviceView.serviceType = selectedService.type
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        // before the view disappears stop any browsers.
        myBonjourServiceBrowser.stop()
    }

    // MARK: Delegate callbacks
    
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        print("Starting to search services")
    }
    
    // Called for each service search
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print("Did not search for services")
    }
    
    // Called for each service found
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {

        let newIndexPath = IndexPath(row: foundServices.count, section: 0)
        
        foundServices += [service.name]
        services += [service]

        print("Found service - \(service.description)")
        
        tableView.insertRows(at: [newIndexPath], with: .bottom)
        
    }
    
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        // The search has stopped for the current search.  If we have more searches to perform then start them.
        print("Got stop")
    }

}
