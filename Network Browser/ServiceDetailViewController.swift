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
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        guard let data = sender.addresses?.first else { return }
        data.withUnsafeBytes { (pointer:UnsafePointer<sockaddr>) -> Void in
            guard getnameinfo(pointer, socklen_t(data.count), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 else {
                return
            }
        }
        let ipAddress = String(cString:hostname)
        print(ipAddress)


        print("got address - hostname = \(sender.hostName!)")
        print("found \((sender.addresses!).count) addresses")
        serviceHostName.text = sender.hostName!
        let dict = NetService.dictionary(fromTXTRecord: sender.txtRecordData()!)

        print(sender.addresses)
        
        var txtRec = ""
        for (name, val) in dict {
            txtRec += name + "=" + String(data: val, encoding:String.Encoding.utf8)! + "\n"
        }

        serviceTXTRecord.text = txtRec
        
        for addr in (sender.addresses)! {
            // addr is a raw but it represents a sockaddr_in()
            // make a mutable copy as this will be used in an in/out parameter.
            var a = addr
            
            // Create a buffer large enough to hold the resulting address string
            var buffer = [CChar](repeating: 0, count: Int(INET_ADDRSTRLEN))
            
            withUnsafePointer(to: &a) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                    print("len = \($0.pointee.sa_len)")
                    print("af_family = \($0.pointee.sa_family)")
                }
            }
            
            withUnsafePointer(to: &a) {
                $0.withMemoryRebound(to: sockaddr_in.self, capacity: 1) {
                    var ss = $0.pointee.sin_addr
                    var len = $0.pointee.sin_len
                    var port = $0.pointee.sin_port
                    print(port)
                    inet_ntop(Int32($0.pointee.sin_family), &ss, &buffer, socklen_t(buffer.count))
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
