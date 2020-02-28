//
//  ApiController.swift
//  SmileSticker
//
//  Created by Justin Allen on 2/28/20.
//  Copyright © 2020 Justin Allen. All rights reserved.
//

import Foundation
import UIKit

// http://www.appsdeveloperblog.com/http-post-request-example-in-swift/
class ApiController : UIViewController {
    
    struct UsageModel: Codable {
        var userId: Int
        var id: Int?
        var title: String
        var completed: Bool
    }
    
    private static let API_Endpoint = "https://api-v1.smartsmilesticker.app/iOS/";
    
    // MARK: View Lifecycles
    override func viewDidLoad() {
        // Place code here.
        super.viewDidLoad()
    }
    
    public static func SubmitReport(_ usage: UsageModel){
        // Prepare URL
        let url = URL(string: ApiController.API_Endpoint)
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(usage)
            request.httpBody = jsonData
            
            // Perform HTTP Request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
                    // Check for Error
                    if let error = error {
                        print("Error took place \(error)")
                        return
                    }
             
                    // Convert HTTP Response Data to a String
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        print("Response data string:\n \(dataString)")
                        // can decode response here if we want.
                    }
            }
            task.resume()
        } catch {
            print("error")
            print(error)
        }
        
        
    }
    
}
