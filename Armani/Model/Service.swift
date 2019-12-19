//
//  Service.swift
//  Armani
//
//  Created by Samahir Adi on 18/12/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import Foundation
import Alamofire

class Service {
    
    // MARK: - Initialize
    
    static let shared = Service()
    private init() {}
    
    // MARK: - Variables
    
    let apiUrl = URL(string: "https://admin-modiface-dev.herokuapp.com/api/v1/devices/get-catalog")
    
    // MARK: - Methods
    
    func getProductElement(callback: @ escaping ([ProductElement]) -> Void) {
        
        let headers: HTTPHeaders =  [
            "Accept": "*/*",
            "Accept-Encoding": "gzip, deflate",
            "Authorization": "Bearer QJt4iApV6b49fNaIpsf9bQR7cD0yDFjrDlDZ.6cb7HWugM8Lr9ffZjt5Qtgl8vzzzwj9WqarT"
        ]
        
        guard let url = apiUrl else {return}
        let request = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
        
        request.responseData { (data) in
            switch data.result {
            case .failure(let error):
                print (error)
            case .success:
                if let body = data.value {
                    let result = try? JSONDecoder().decode(Product.self, from: body)
                    let productsArray = result?.data?.products?.compactMap({ (product) in
                        product
                    }) ?? []
                    callback(productsArray)
                    print (body)
                }
            }
        }
    }
   
}
