//
//  AppDelegate.swift
//  MovieListApp
//
//  Created by Junaid Butt on 25/05/2022.
//

import UIKit
import Network
import NotificationBannerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //self.configureNetworkMonitor()
        ConnectionManager.sharedInstance.observeReachability()
        ConnectionManager.sharedInstance.delegate = self
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func configureNetworkMonitor(){
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { path in
            
            if path.status != .satisfied {
                print("not connected")
            }
            else if path.usesInterfaceType(.cellular) {
                print("Cellular")
            }
            else if path.usesInterfaceType(.wifi) {
                print("WIFI")
            }
            else if path.usesInterfaceType(.wiredEthernet) {
                print("Ethernet")
            }
            else if path.usesInterfaceType(.other){
                print("Other")
            }else if path.usesInterfaceType(.loopback){
                print("Loop Back")
            }
        }
        
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
}

extension AppDelegate: InternetConnection {
    func connectionUpdated(isOnline: Bool) {
        let banner = NotificationBanner(title: "You're Offline!", subtitle: "Internet connection appears to be offline.", style: .danger)
        !isOnline ? banner.show(bannerPosition: .top) : banner.hideToast()
    }
}
