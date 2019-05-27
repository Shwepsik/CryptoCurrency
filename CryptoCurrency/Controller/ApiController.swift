//
//  ApiController.swift
//  CryptoCurrency
//
//  Created by Valerii on 26.04.2019.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import Alamofire

typealias JSON = [String: AnyObject]
typealias ResponseBlock = (_ result: Any?, _ error: Error?)
    -> Void


class ApiController {
    
    
    static let shared = ApiController()
    
    let header: HTTPHeaders = ["X-CMC_PRO_API_KEY": "a1f7bcab-3333-4211-8d5a-9ac08f13c117",
        "Accept": "application/json"]
    
    let baseUrl: String = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/"

    
    func tryLoadInfo(method: HTTPMethod, params: Parameters?, headers: HTTPHeaders?, path: String, responseBlock: @escaping ResponseBlock) {

        let fullPath: String = baseUrl + path
        
        if let url: URL = URL(string: fullPath) {
            
            request(url, method: method, parameters: params, headers: headers).validate().responseJSON { (responseJSON) in
                switch responseJSON.result {
                case .success:
                    guard let jsonArray = responseJSON.result.value as? JSON else {
                        return
                    }
                    
                    responseBlock(jsonArray,nil)
                    
                    
                case .failure(let error):
                    print(error)
                    responseBlock(nil,error)
                    
                }
            }
        }
    }
    
    func tryLoadCoinInfo(_ responseBlock: @escaping (GetCoinInfoResponse) -> Void) {
        tryLoadInfo(method: .get, params: nil, headers: header, path: "listings/latest") { (response, error) in
            if let json = response as? JSON {
                let coinInfoResponse = GetCoinInfoResponse(json: json)
                responseBlock(coinInfoResponse!)
            }
        }
    }
 
    
    func tryLoadCoinImage(param: [String: String], _ responseBlock: @escaping (GetImageResponse) -> Void) {
        tryLoadInfo(method: .get, params: param, headers: header, path: "info") { (response, error) in
            if let json = response as? JSON {
                let imageResponse = GetImageResponse(json: json)
                responseBlock(imageResponse!)
            }
        }
    }
}
