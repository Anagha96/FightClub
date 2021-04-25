//
//  Utility.swift
//  FightClub
//
//  Created by Anagha Wadkar on 24/04/21.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        
        //TODO: Image Cache Implementation 
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                if error == nil {
                    if let data = data {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.image = image
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
