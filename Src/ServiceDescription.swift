//
//  ServiceDescription.swift
//  Network Browser
//
//  Dictionary of friendly service names and descriptions.
//
//  Created by Thomas Petz, Jr. on 12/31/16.
//  Copyright © 2016 Thomas J. Petz, Jr. All rights reserved.
//

import Foundation

struct ServiceDescription {
    let friendlyName: String
    let description: String
}


let serviceDescriptions: [String: ServiceDescription] =
    [
     "_rfb": ServiceDescription(friendlyName: "Remote Framebuffer", description: "Remote Framebuffer service is used for remote desktop access by VNC"),
     "_workstation": ServiceDescription(friendlyName: "Microsoft Windows Workstation", description: "Basic windows client workstation services - NetBios services"),
     "_raop": ServiceDescription(friendlyName: "Apple Remote Audio Protocol", description: "Protocol for iTunes audio streaming"),
     "_adisk": ServiceDescription(friendlyName: "Apple Time Machine", description: "Time Machine backup service"),
     "_soundtouch": ServiceDescription(friendlyName: "Bose Soundtouch", description: "Bose Soundtouch remote control"),
     "_smb": ServiceDescription(friendlyName: "Windows File Share", description: "Service Message Block file share protocol"),
     "_ipp": ServiceDescription(friendlyName: "Internet Print Protocol", description: "Printing protocol"),
     "_ipps": ServiceDescription(friendlyName: "Secure Internet Print Protocol", description: "Secure printing protocol"),
     "_device-info": ServiceDescription(friendlyName: "ReadyNAS discovery prototol", description: "Discovery protocol for Netgear ReadyNAS NAS devices."),
     "_home-sharing": ServiceDescription(friendlyName: "Apple iTunes sharing protocol", description: "Apple iTunes sharing protocol"),
     "_homekit": ServiceDescription(friendlyName: "Apple HomeKit services", description: "Apple HomeKit home automation protocol"),
     "_http": ServiceDescription(friendlyName: "Web Server", description: "HTTP accessible web server"),
     "_sleep-proxy": ServiceDescription(friendlyName: "Apple Bonjour Sleep Proxy", description: "Proxies Bonjour services for sleeping devices."),
     "_airplay": ServiceDescription(friendlyName: "Apple AirPlay screen mirroring", description: "Apple AirPlay screen mirroring"),
     "_appletv-v2": ServiceDescription(friendlyName: "AppleTV remote control", description: "AppleTV remote control protocol"),
     "_afpovertcp": ServiceDescription(friendlyName: "Apple File Sharing", description: "Apple File Shareing Protocol over TCP"),
     "_spotify-connect": ServiceDescription(friendlyName: "Spotify streaming receiver", description: "Spotify streaming receiver"),
     "_scanner": ServiceDescription(friendlyName: "Desktop scanner service", description: "Desktop scanner service")
    ]


