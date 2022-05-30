//
//  ConnectionManager.swift
//  MovieListApp
//
//  Created by Junaid Butt on 27/05/2022.
//

import Foundation

class ConnectionManager {
    
    static let sharedInstance = ConnectionManager()
    private var reachability: Reachability!
    weak var delegate: InternetConnection?
    
    func observeReachability() {
        self.reachability = try! Reachability()
        NotificationCenter.default.addObserver(self, selector:#selector(self.reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
        do {
            try self.reachability.startNotifier()
        }
        catch(let error) {
            print("Error occured while starting reachability notifications : \(error.localizedDescription)")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .cellular, .wifi:
            print("cellular and wifi")
            delegate?.connectionUpdated(isOnline: true)
            break
        case .unavailable:
            print("Network is not available.")
            delegate?.connectionUpdated(isOnline: false)
            break
        }
    }
}

protocol InternetConnection: AnyObject {
    func connectionUpdated(isOnline: Bool)
}
