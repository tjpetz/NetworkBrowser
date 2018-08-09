//
//  ServiceDetailTableViewController.swift
//  Network Browser
//
//  Created by Thomas Petz, Jr. on 8/8/18.
//  Copyright © 2018 Thomas J. Petz, Jr. All rights reserved.
//

import UIKit

class ServiceDetailTableViewController: UITableViewController, NetServiceDelegate {

    var service: NetService? = nil

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var hostname: UILabel!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var addresses: UILabel!
    @IBOutlet weak var txtRecord: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        name.text = service?.name
        type.text = service?.type
        hostname.text = service?.hostName
        domain.text = service?.domain
 
        // To get most of the information about the service we need to resolve it
        service?.delegate = self
        service?.resolve(withTimeout: 10.0)
   }
/*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    override func viewWillDisappear(_ animated: Bool) {
        // before the view disappears stop any resolvers.
        service!.stop()
    }

    // MARK: Delegate callbacks
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        var addr_values : String = ""
        var txtRec = ""
        
        // With resolution the host name, TXT record, and addresses are available.
        
        hostname.text = sender.hostName!
        
        let dict = NetService.dictionary(fromTXTRecord: sender.txtRecordData()!)
        for (name, val) in dict {
            // The data in the txtRecord is supposed to be utf8 encoded.  However,
            // I've seen at least one instance where this was not the case and therefore
            // the conversion to a string failed.  Creating a String(data:_,_) fails
            // with an illformed utf8 string.  This technique is from: https://stackoverflow.com/questions/44611598/cleaning-malformed-utf8-strings
            //
            var val_buff = val
            val_buff.append(0)      // stick a null on the end
            let sVal = val_buff.withUnsafeBytes { (p: UnsafePointer<CChar>) in String(cString: p) }
            
            txtRec += name + "=" + sVal + "\n"
        }
        
        txtRecord.text = txtRec
        
        for addr in (sender.addresses)! {
            // addr is a Data but it is of type sockaddr_in().  To work with the structure
            // we first access it as the generic sockaddr type to find the address family.
            // Once we know the address family we can then use the protocol specific
            // sockaddr_XX.  Note, in our case we're assuming we only get back IPv4 or IPv6
            // addresses.  It's should be possible but probably not common to get other
            // address types.
            
            // To determine the address family we access the data as a sockaddr.
            let af_family = addr.withUnsafeBytes {
                (p: UnsafePointer<sockaddr>) -> Int32 in
                return (Int32(p.pointee.sa_family))
            }
            
            // Now that we know the address family we can access the data using the
            // specific sockaddr_XX type to retrieve the address.
            if (af_family == AF_INET) {
                // Get IPv4 addresses
                // Create a buffer large enough to hold the resulting address string
                var buffer = [CChar](repeating: 0, count: Int(INET_ADDRSTRLEN))
                addr.withUnsafeBytes {
                    (p: UnsafePointer<sockaddr_in>) -> Void in
                    var ss = p.pointee.sin_addr
                    inet_ntop(AF_INET, &ss, &buffer, socklen_t(buffer.count))
                }
                addr_values += "\(String(cString:buffer))\n"
            } else if (af_family == AF_INET6) {
                // Get IPv6 addresses
                // Create a buffer large enough to hold the resulting address string
                var buffer = [CChar](repeating: 0, count: Int(INET6_ADDRSTRLEN))
                addr.withUnsafeBytes {
                    (p: UnsafePointer<sockaddr_in6>) -> Void in
                    var ss = p.pointee.sin6_addr
                    inet_ntop(AF_INET6, &ss, &buffer, socklen_t(buffer.count))
                }
                addr_values += "\(String(cString:buffer))\n"
            } else {
                addr_values += "Unknown Address Type\n"
            }
        }
        
        addresses.text = addr_values
    }

    func netServiceDidStop(_ sender: NetService) {
        print("got did stop")
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("did not resolve")
        hostname.text = "ERROR: unable to resolve"
    }

}
