//
//  BMHttpTools.swift
//  BMKit
//
//  Created by bymost on 14/03/2018.
//

import UIKit
import Alamofire
import SwiftyJSON

public class BMHttpTools: NSObject {
    
    /// get请求
    ///
    /// - Parameters:
    ///   - url: url地址
    ///   - params: 参数
    ///   - completionBlock: 成功
    ///   - failBlock: 失败
    public class func getRequest(url: String, params: Parameters, completionBlock: @escaping requestSuccessCompletionBlock, failBlock: @escaping requestFailureBlock){
        let paramters = self.paramsAddProperty(parameters: params)
        BMPrint("\nurl   = \(url) \nparam = \(JSON(paramters))")
        Alamofire.request(url, method: .get, parameters: paramters, encoding: URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { (response) in
                if let error = response.result.error{
                    #if DEBUG
                        failBlock(error)
                    #else
                        let err = error as NSError
                        failBlock(BMCustomError.init(reCode: err.code, reMsg: err.localizedDescription))
                    #endif
                }else{
                    if let json = response.result.value{
                        let data = JSON(json)
                        if let reCode = data["reCode"].string{
                            if reCode == "1"{
                                completionBlock(json)
                            }else{
                                if reCode == "-2"{
                                    failBlock(BMCustomError.init(reCode: data["reCode"].intValue, reMsg: data["reMsg"].stringValue))
                                }else{
                                    failBlock(BMCustomError.init(reCode: data["reCode"].intValue, reMsg: data["reMsg"].stringValue))
                                }
                            }
                        }
                    }
                }
            })
    }
    
    /// post请求
    ///
    /// - Parameters:
    ///   - url: url地址
    ///   - params: 参数
    ///   - completionBlock: 成功
    ///   - failBlock: 失败
    public class func postRequest(url: String, params: Parameters, completionBlock: @escaping requestSuccessCompletionBlock, failBlock: @escaping requestFailureBlock){
        let paramters = self.paramsAddProperty(parameters: params)
        BMPrint("\nurl   = \(url) \nparam = \(JSON(paramters))")
        Alamofire.request(url, method: .post, parameters: paramters, encoding: URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { (response) in
                if let error = response.result.error{
                    #if DEBUG
                        failBlock(error)
                    #else
                        let err = error as NSError
                        failBlock(BMCustomError.init(reCode: err.code, reMsg: err.localizedDescription))
                    #endif
                }else{
                    if let json = response.result.value{
                        let data = JSON(json)
                        if let reCode = data["reCode"].string{
                            if reCode == "1"{
                                completionBlock(json)
                            }else{
                                if reCode == "-2"{
                                    failBlock(BMCustomError.init(reCode: data["reCode"].intValue, reMsg: data["reMsg"].stringValue))
                                }else{
                                    failBlock(BMCustomError.init(reCode: data["reCode"].intValue, reMsg: data["reMsg"].stringValue))
                                }
                            }
                        }
                    }
                }
            })
    }
    
    /// post - multipart请求
    ///
    /// - Parameters:
    ///   - url: url地址
    ///   - params: 需要拼接到multipartFormData中的内容 key是拼接的name, value是拼接的数据
    ///              注意: value只能是String或UIImage,如果value是图片 会将图片压缩到1MB以下
    ///   -uploadProgress: 上传进度
    ///   - completionBlock: 成功
    ///   - failBlock: 失败
    public class func upload(url: String, params: [String: Any], uploadProgress: uploadProgressBlock?,completionBlock:@escaping requestSuccessCompletionBlock, failBlock: @escaping requestFailureBlock) {
        let paramters = self.paramsAddProperty(parameters: params)
        BMPrint("\nurl   = \(url) \nparam = \(JSON(paramters))")
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (string, obj) in paramters {
                if let partStr = obj as? String {
                    multipartFormData.append(partStr.data(using: .utf8)!, withName: string)
                }else if let partImage = obj as? UIImage {
                    multipartFormData.append(partImage.dataForUpload(), withName: string, fileName: "default", mimeType: "image/png")
                }else {
                    BMPrintError("\(#function) -> 不支持的类型")
                }
            }
        }, to: url) { (encodingResult) in
            switch encodingResult {
            case .success(let uploadRequest, _, _):
                if uploadProgress != nil {
                    uploadRequest.uploadProgress(closure: { (progress) in
                        uploadProgress?(progress)
                    })
                }
                uploadRequest.responseJSON(completionHandler: { (response) in
                    if let error = response.result.error{
                        #if DEBUG
                            failBlock(error)
                        #else
                            let err = error as NSError
                            failBlock(BMCustomError.init(reCode: err.code, reMsg: err.localizedDescription))
                        #endif
                    }else{
                        if let json = response.result.value{
                            let data = JSON(json)
                            if let reCode = data["reCode"].string{
                                if reCode == "1"{
                                    completionBlock(json)
                                }else{
                                    if reCode == "-2"{
                                        failBlock(BMCustomError.init(reCode: data["reCode"].intValue, reMsg: data["reMsg"].stringValue))
                                    }else{
                                        failBlock(BMCustomError.init(reCode: data["reCode"].intValue, reMsg: data["reMsg"].stringValue))
                                    }
                                }
                            }
                        }
                    }
                })
            case .failure(let error):
                BMPrintError("\(#function) -> \(error)")
            }
        }
    }
    
    /// 上传图片数组，可规定每张图片名称
    ///
    /// - parameter url:             请求链接
    /// - parameter params:          请求参数
    /// - parameter imageDatas:      图片数组
    /// - parameter imageNames:      图片名字数组
    /// - parameter uploadProgress:  上传进度闭包
    /// - parameter completionBlock: 成功闭包
    /// - parameter failBlock:       失败闭包
    class func upload(url: String, params: Parameters, imageDatas: [UIImage], imageNames : [String],uploadProgress : uploadProgressBlock?,completionBlock: @escaping requestSuccessCompletionBlock, failBlock: @escaping requestFailureBlock){
        let parameter = self.paramsAddProperty(parameters: params)
        BMPrint("\nurl   = \(url) \nparam = \(JSON(parameter))")
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for(string , obj) in parameter {
                if let objString = obj as? String {
                    multipartFormData.append(objString.data(using: .utf8)!, withName: string)
                }
            }
            
            for index in 0 ..< imageDatas.count {
                if index >= imageNames.count {
                    multipartFormData.append(imageDatas[index].dataForUpload(), withName: "file", fileName: String.init(format: "image_%d", index + 1), mimeType: "image/png")
                }else {
                    multipartFormData.append(imageDatas[index].dataForUpload(), withName: "file", fileName: imageNames[index], mimeType: "image/png")
                }
            }
            
        }, to: url) { (encodingResult) in
            switch encodingResult {
            case .success(let uploadRequest, _, _):
                if uploadProgress != nil {
                    uploadRequest.uploadProgress(closure: { (progress) in
                        uploadProgress?(progress)
                    })
                }
                uploadRequest.responseJSON(completionHandler: { (response) in
                    if let error = response.result.error{
                        #if DEBUG
                            failBlock(error)
                        #else
                            let err = error as NSError
                            failBlock(BMCustomError.init(reCode: err.code, reMsg: err.localizedDescription))
                        #endif
                    }else{
                        if let json = response.result.value{
                            let data = JSON(json)
                            if let reCode = data["reCode"].string{
                                if reCode == "1"{
                                    completionBlock(json)
                                }else{
                                    if reCode == "-2"{
                                        failBlock(BMCustomError.init(reCode: data["reCode"].intValue, reMsg: data["reMsg"].stringValue))
                                    }else{
                                        failBlock(BMCustomError.init(reCode: data["reCode"].intValue, reMsg: data["reMsg"].stringValue))
                                    }
                                }
                            }
                        }
                    }
                })
            case .failure(let error):
                BMPrintError("\(#function) -> \(error)")
            }
        }
    }
    
    /**
     *  设置请求参数
     *
     *  @param params 请求参数
     *
     *  @return params
     */
    private class func paramsAddProperty(parameters: Parameters?) -> Parameters{
        var params = parameters ?? [String: Any]()
        //设置token
        //        let account = ZLAccountTool.getAccountFromArchive()
        //params["token"] ?? account?.token;
        //        params["token"] = ZLAccountTool.getAccountFromKeychain()?.token
        
        //设置接口访问来源平台
        params["appOrigin"] = "TTTW_IOS";
        
        //设置系统版本号
        let models = UIDevice.current.modelName
        let systemVesion = UIDevice.current.systemVersion
        let phoneType = models + "_" + systemVesion //[NSString stringWithFormat:@"%@_%@",models,systemVesion];
        params["phoneType"] = phoneType
        
        //设置客户端版本号
        let key = "CFBundleVersion"
        let currentVesion = Bundle.main.infoDictionary?[key]
        params["version"] = currentVesion
        
        //设置设备号
        let uuid: UUID = UIDevice.current.identifierForVendor!
        let deviceUDID = uuid.uuidString
        params["deviceId"] = deviceUDID
        
        //设置请求的条数（分页查询）
        params["pageSize"] = params["pageSize"] ?? 10
        
        //设置个推推送id
        params["clientId"] = UserDefaults.standard.object(forKey: CONSTANT_GETUI_CLIENT_ID)
        return params
    }
    
}
