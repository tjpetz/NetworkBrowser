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
//        serviceDescription.text = service?.description
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
        print("got address - hostname = \(sender.hostName!)")
        serviceHostName.text = sender.hostName!
        let dict = NetService.dictionary(fromTXTRecord: sender.txtRecordData()!)

        var txtRec = ""
        for (name, val) in dict {
            txtRec += name + "=" + String(data: val, encoding:String.Encoding.utf8)! + "\n"
        }

        serviceTXTRecord.text = txtRec
        
        print(sender.addresses?.debugDescription)
        
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
        serviceHostName.text = "ERROR: unable to resolve"
    }
}
