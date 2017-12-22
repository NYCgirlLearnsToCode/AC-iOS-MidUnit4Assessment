//
//  ImageAPIClient.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Lisa J on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
import UIKit
//have to import UIKit to use UIimage

class ImageAPIClient {
    private init() {}
    static let manager = ImageAPIClient()
    func getImage(from urlStr: String,
                  completionHandler: @escaping (UIImage?) -> Void,
                  errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else {return}
        let request = URLRequest(url:url)
        let completion: (Data) -> Void = {(data: Data) in
            guard let onlineImage = UIImage(data: data) else {return}
            completionHandler(onlineImage)
        }
        NetworkHelper.manager.performDataTask(with: request,
                                              completionHandler: completion,
                                              errorHandler: errorHandler)
    }
}
