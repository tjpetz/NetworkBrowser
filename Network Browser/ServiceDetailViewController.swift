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
//    @IBOutlet weak var serviceDescription: UILabel!
//    @IBOutlet weak var serviceAddresses: UILabel!
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
        print("got address - hostname = \(sender.hostName!)")
        print("found \((sender.addresses!).count) addresses")
        serviceHostName.text = sender.hostName!
        let dict = NetService.dictionary(fromTXTRecord: sender.txtRecordData()!)

        var txtRec = ""
        for (name, val) in dict {
            txtRec += name + "=" + String(data: val, encoding:String.Encoding.utf8)! + "\n"
        }

        serviceTXTRecord.text = txtRec
        
        print(sender.addresses?.debugDescription as Any)
        
        for addr in (sender.addresses)! {
            // addr is a raw but it represents a sockaddr_in()
            // make a mutable copy as this will be used in an in/out parameter.
            var a = addr
            
            // Create a buffer large enough to hold the resulting address string
            var buffer = [CChar](repeating: 0, count: Int(INET6_ADDRSTRLEN))
            
            withUnsafePointer(to: &a) {
                $0.withMemoryRebound(to: sockaddr_in6.self, capacity: 1) {
                    var ss = $0.pointee.sin6_addr
                    var len = $0.pointee.sin6_len
                    var port = $0.pointee.sin6_port
                    if ($0.pointee.sin6_family == AF_INET) {
                        inet_ntop(AF_INET, &ss, &buffer, socklen_t(Int(INET_ADDRSTRLEN)))
                    } else {
                        inet_ntop(AF_INET6, &ss, &buffer, socklen_t(Int(INET_ADDRSTRLEN)))
                    }
                }
            }
       
            print(String(cString: buffer))
            
            //           inet_ntop(AF_INET, &bob, &buffer, socklen_t(Int(INET_ADDRSTRLEN)))
            //           let addr_prnt = String(data: buffer, encoding: String.UTF8View)
            //           print(String(utf8String: buffer)!)
        }
        
    }
    

    func netServiceDidStop(_ sender: NetService) {
        print("got did stop")
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("did not resolve")
        serviceHostName.text = "ERROR: unable to resolve"
    }
}
