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
        service?.resolve(withTimeout: 20.0)
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
            // addr is a raw but it represents a sockaddr_in()
            
            // Create a buffer large enough to hold the resulting address string
            var buffer = [CChar](repeating: 0, count: Int(INET6_ADDRSTRLEN))
 
            // Look for IPv4 addresses
            addr.withUnsafeBytes {
                (p: UnsafePointer<sockaddr_in>) -> Void in
                if (p.pointee.sin_family == AF_INET) {
                    var ss = p.pointee.sin_addr
                    inet_ntop(AF_INET, &ss, &buffer, socklen_t(buffer.count))
                }
            }

            // Look for IPv6 addresses
            addr.withUnsafeBytes {
                (p: UnsafePointer<sockaddr_in6>) -> Void in
                if (p.pointee.sin6_family == AF_INET6) {
                    var ss = p.pointee.sin6_addr
                    inet_ntop(AF_INET6, &ss, &buffer, socklen_t(buffer.count))
                }
            }
            addr_values += "\(String(cString:buffer))\n"
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
