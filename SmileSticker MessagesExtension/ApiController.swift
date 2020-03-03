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

extension UIColor {
    func hex() -> String{
        let (r, g, b, _) = self.rgba
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return NSString(format:"#%06x", rgb) as String
    }
}

class ApiController : UIViewController {
    
//    struct Color : Codable {
////        var red : CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
//        var hex: String = ""
//
////        var uiColor : UIColor {
////            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
////        }
//
//        init(uiColor : UIColor) {
////            uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
//            let (r, g, b, _) = uiColor.rgba
//
//            let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
//
//            hex = NSString(format:"#%06x", rgb) as String
//        }
//    }
    
//    struct UsageData: Codable {
//        var color: Color
//        var slider: Float
//    }
    
    struct UsageModel: Codable {
        var BundleID: String
        var AppVersion: String
        var BuildNumber: String
        // could add device id...
        var color: String
        var slider: Float
//        var Data: UsageData
    }
    
    #if targetEnvironment(simulator)
        private static let API_Endpoint = "http://192.168.1.49:8000/iOS/";
        private static let API_ClientID = "ztuJ7pX3WJOzKXCPittDvR8Tn";
    #else
    private static let API_Endpoint: String = {
        let v: String = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
        return "https://api-v1.smartsmilesticker.app/iOS/\(v)"
    }()
//        private static let API_Endpoint = "https://api-v1.smartsmilesticker.app/iOS/" + Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String;
        private static let API_ClientID = "I6hiRgR7a53wVOHXYYJx9yhbF";
    #endif
    
    
//    private static let API_Endpoint = "http://192.168.1.49:8000/iOS/";
    
    // MARK: View Lifecycles
    override func viewDidLoad() {
        // Place code here.
        super.viewDidLoad()
    }
    
    // TODO: add call back for success/error
    public static func SubmitReport(_ usage: UsageModel){
        // Prepare URL
        let url = URL(string: ApiController.API_Endpoint)
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(ApiController.API_ClientID, forHTTPHeaderField: "Authorization")

        do {
            let jsonData = try JSONEncoder().encode(usage)
            request.httpBody = jsonData
            print(usage)
//            print(request.httpBody)
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
