//
//  InternectConnectivity+Extension.swift
//  MovieListApp
//
//  Created by Junaid Butt on 26/05/2022.
//

import Foundation
import Alamofire

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}


