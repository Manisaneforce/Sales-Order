//
//  S3.swift
//  Sales Order
//
//  Created by San eforce on 30/10/23.
//

import Foundation
import Alamofire
import AWSS3
import AWSCore
//class S3ViewModel: ObservableObject {
//    func uploadPhotoToS3(imageData: Data, bucketName: String, fileName: String) {
//        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: "fmcg_1",
//                                                              secretKey: "f(2L21MPR")
//        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
//        
//        AWSServiceManager.default()?.defaultServiceConfiguration = configuration
//        
//        let transferManager = AWSS3TransferManager.default()
//            
//        let uploadRequest = AWSS3TransferManagerUploadRequest()!
//        
//        uploadRequest.bucket = bucketName
//        uploadRequest.key = fileName
//        uploadRequest.body = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
//        
//        transferManager?.upload(uploadRequest).continueWith { (task) -> AnyObject? in
//            if let error = task.error {
//                print("Error uploading photo: \(error)")
//                print(error)
//            }
//            if task.result != nil {
//                print("Upload successful")
//            }
//            return nil
//        }
//        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
//        
//        do {
//            try imageData.write(to: fileURL)
//        } catch {
//            print("Error writing file: \(error)")
//            let data = error
//            print("Error data In S3 \(data)")
//        }
//    }
//}
//
