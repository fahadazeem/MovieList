//
//  StoryBoard+Extension.swift
//  MovieListApp
//
//  Created by Junaid Butt on 25/05/2022.
//

import Foundation
import UIKit

/// A protocol that lets us instantiate view controllers from Main storyboard.
protocol Storyboarded { }

extension Storyboarded where Self: UIViewController {
    
    static func instantiateMain() -> Self {
        let storyboardIdentifier = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
            fatalError("No storyboard with this identifier ")
        }
        return vc
    }
}
extension UIViewController:Storyboarded{}
