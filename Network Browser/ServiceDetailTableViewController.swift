//
//  ServiceDetailTableViewController.swift
//  Network Browser
//
//  Created by Thomas Petz, Jr. on 10/29/16.
//  Copyright © 2016 Thomas J. Petz, Jr. All rights reserved.
//

import UIKit

class ServiceDetailTableViewController: UITableViewController, NetServiceDelegate {

    var service: NetService? = nil

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var hostname: UILabel!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var txtRecord: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // To get most of the information about the service we need to resolve it
        service?.delegate = self
        service?.resolve(withTimeout: 10.0)

        // Display the data
        name.text = service?.name
        type.text = service?.type
        hostname.text = "Searching..."
        domain.text = service?.domain
        txtRecord.text = "Searching..."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        cell.textLabel?.text = "Hi!"
//
//        return cell
//    }
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Delegate callbacks
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        print("got address - hostname = \(sender.hostName!)")
        hostname.text = sender.hostName!
        let dict = NetService.dictionary(fromTXTRecord: sender.txtRecordData()!)
        
        var txtRec = ""
        for (name, val) in dict {
            txtRec += name + "=" + String(data: val, encoding:String.Encoding.utf8)! + "\n"
        }
        
        txtRecord.text = txtRec
        
//        print(sender.addresses?.debugDescription)
        
        //       CFData
        //        for i in sender.addresses! {
        //            print(i.description)
        //        }
        //        serviceAddresses.text = sender.addresses?.debugDescription
    }
    
    func netServiceDidStop(_ sender: NetService) {
        print("got did stop")
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("did not resolve")
        hostname.text = "ERROR: unable to resolve"
    }

}
