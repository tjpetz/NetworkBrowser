//
//  ServiceDetailViewController.swift
//  Network Browser
//
//  Created by Thomas Petz, Jr. on 12/30/15.
//  Copyright © 2015 Thomas J. Petz, Jr. All rights reserved.
//

import UIKit

class ServiceDetailViewController: UIViewController, NetServiceDelegate {

    // MARK: Properties
    
    var service: NetService? = nil
    
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceType: UILabel!
    @IBOutlet weak var serviceHostName: UILabel!
    @IBOutlet weak var serviceDomain: UILabel!
    @IBOutlet weak var serviceAddresses: UILabel!
    @IBOutlet weak var serviceTXTRecord: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        serviceName.text = service?.name
        serviceType.text = service?.type
        serviceDomain.text = service?.domain
        serviceHostName.text = "searching..."
        serviceTXTRecord.text = service?.txtRecordData()?.description
        
        // To get most of the information about the service we need to resolve it
        service?.delegate = self
        service?.resolve(withTimeout: 10.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
        
        serviceHostName.text = sender.hostName!
 
        let dict = NetService.dictionary(fromTXTRecord: sender.txtRecordData()!)
        for (name, val) in dict {
            txtRec += name + "=" + String(data: val, encoding:String.Encoding.utf8)! + "\n"
        }

        serviceTXTRecord.text = txtRec
        
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
        
        serviceAddresses.text = addr_values
    }
    

    func netServiceDidStop(_ sender: NetService) {
        print("got did stop")
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("did not resolve")
        serviceHostName.text = "ERROR: unable to resolve"
    }
}
