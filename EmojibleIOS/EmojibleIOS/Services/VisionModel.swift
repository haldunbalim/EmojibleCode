//
//  VisionModel.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 23.12.2020.
//

import Foundation
import UIKit
import Alamofire


class VisionModel{
    
    private init(){
    }
    
    
    func predictEmojis(image:UIImage, completion:@escaping ((String?)->Void)){
            let imgData = image.pngData()!

            let parameters:[String:String] = [:] //Optional for extra parameter

            Alamofire.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(imgData, withName: "file",fileName: "a.png", mimeType: "image/png")
                    for (key, value) in parameters {
                            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                        } //Optional for extra parameters
                },
            
            to:Constants.VisionModelURL)
            { (result) in
                switch result {
                case .success(let upload, _, _):

                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })

                    upload.responseJSON { response in
                        //no response
                        guard let val = response.result.value as? [String:Any] else{ return }
                        guard let code = val["code"] as? String else { return }
                        completion(code)
                    }

                case .failure(let encodingError):
                    print(encodingError)
                    completion(nil)
                }
            }
        }

    
    
    private static let instance = VisionModel()
    public static func getInstance() -> VisionModel{
        return .instance
    }
}
