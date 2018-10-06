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

    var name = ""
    var type = ""
    var hostname = "resolving..."
    var domain = ""
    var addresses: [String] = []
    var txtRecords: [String] = []
    var hostnameTableCell: ServiceDetailHostNameTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        name = (service?.name)!
        type = (service?.type)!
        domain = (service?.domain)!
 
        // To get most of the information about the service we need to resolve it
        service?.delegate = self
        service?.resolve(withTimeout: 2.0)
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows for each section
        switch section {
        case 0: return 4
        case 1: return addresses.count
        case 2: return txtRecords.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // return the title for each section
        switch (section) {
        case 0 : return ""
        case 1: return "Addresses"
        case 2: return "TXT Record"
        default: return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell, the type varies by the section hence we need to switch on the section
        switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
            case 0: do {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceDetailNameTableViewCell", for: indexPath) as! ServiceDetailNameTableViewCell
                cell.name.text = name
                return cell
                }
            case 1: do {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceDetailTypeTableViewCell", for: indexPath) as! ServiceDetailTypeTableViewCell
                cell.type.text = type
                return cell
                }
            case 2: do {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceDetailHostNameTableViewCell", for: indexPath) as! ServiceDetailHostNameTableViewCell
                // save a reference to the cell so that we can easily update it once the hostname resolves.
                hostnameTableCell = cell
                cell.hostname.text = hostname
                return cell
                }
            case 3: do {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceDetailDomainTableViewCell", for: indexPath) as! ServiceDetailDomainTableViewCell
                cell.domain.text = domain
                return cell
                }
            default: break
            }
        case 1: do {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceDetailAddressTableViewCell", for: indexPath) as! ServiceDetailAddressTableViewCell
            cell.address.text = addresses[indexPath.row]
            return cell
            }
        case 2: do {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceDetailTxtRecordTableViewCell", for: indexPath) as! ServiceDetailTxtRecordTableViewCell
            cell.txtRecord.text = txtRecords[indexPath.row]
            return cell
            }
        default:
            break;
        }
        
        return UITableViewCell()
    }

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
        
        hostname = sender.hostName!
        hostnameTableCell?.hostname.text = hostname
        
        // Break up the TXT Record and create an array of individual txtRecords
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
            
            txtRec = name + "=" + sVal
            txtRecords += [txtRec]
            
            // Add a row to the section
            let newIndexPath = IndexPath(row: txtRecords.count - 1, section: 2)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
        }
        
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
                addr_values = String(cString:buffer)
            } else if (af_family == AF_INET6) {
                // Get IPv6 addresses
                // Create a buffer large enough to hold the resulting address string
                var buffer = [CChar](repeating: 0, count: Int(INET6_ADDRSTRLEN))
                addr.withUnsafeBytes {
                    (p: UnsafePointer<sockaddr_in6>) -> Void in
                    var ss = p.pointee.sin6_addr
                    inet_ntop(AF_INET6, &ss, &buffer, socklen_t(buffer.count))
                }
                addr_values = String(cString:buffer)
            } else {
                addr_values = "Unknown Address Type"
            }
            
            addresses += [addr_values]

            // Add a row to the addresses section
            let newIndexPath = IndexPath(row: addresses.count - 1, section: 1)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
        }
        
        tableView.setNeedsDisplay()
    }

    func netServiceDidStop(_ sender: NetService) {
        print("got did stop")
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("did not resolve")
        //hostname.text = "ERROR: unable to resolve"
    }

}
