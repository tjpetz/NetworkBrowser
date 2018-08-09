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

class DiscoveredServicesTableViewController: UITableViewController, NetServiceBrowserDelegate {

    // MARK: Properties
    
    var domain: String = ""
    var serviceName: String = ""
    var serviceType: String = ""
    var browseForService: String = ""                  // the name of the service to search for
    var services: [NetService] = []                    // Array to save the services we discover
    let myBonjourServiceBrowser = NetServiceBrowser()  // Bonjour Service Browser
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
     
        // The serviceType we receive includes the domain.  We need to
        // extract the type without the domain name.
//        browseForService = serviceName + "." + serviceType.substring(to: (serviceType.range(of: ".")?.lowerBound)!)
        browseForService = serviceName + "." + serviceType[...(serviceType.index(of: ".")!)]
        print("Search for providers of service - \(browseForService)")
        myBonjourServiceBrowser.delegate = self
        myBonjourServiceBrowser.searchForServices(ofType: browseForService, inDomain: domain)
        
    }

//    override func viewDidAppear(_ animated: Bool) {
//        myBonjourServiceBrowser.searchForServices(ofType: browseForService, inDomain: domain)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoveredServiceTableCell", for: indexPath) as! DiscoveredServiceTableViewCell
        
        // Configure the cell...
        cell.serviceName.text = services[indexPath.row].name
        
        return cell
    }

    override func viewWillDisappear(_ animated: Bool) {
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let serviceView = segue.destination as! ServiceDetailTableViewController
        
        myBonjourServiceBrowser.stop()      // halt any running searches before moving to the detail
        
        // Get the cell that generated this segue.
        if let selectedCell = sender as? DiscoveredServiceTableViewCell {
            let indexPath = tableView.indexPath(for: selectedCell)!
            let selectedService = services[indexPath.row]
            serviceView.service = selectedService
        }
    }

    // MARK: Delegate callbacks
    
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        print("Starting to search services in DiscoveredServicesTableViewControler")
    }
    
    // Called for each service search
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print("Did not search for service in DiscoveredServicesTableViewController")
    }
    
    // Called for each service found
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        
        let newIndexPath = IndexPath(row: services.count, section: 0)
        
        services += [service]
        
        print("Found provider - \(service.name)")
        
        tableView.insertRows(at: [newIndexPath], with: .bottom)
        
    }
    
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        // The search has stopped for the current search.  If we have more searches to perform then start them.
        print("Got service browse stop in DiscoveredServicesTableViewController")
    }
    

}
