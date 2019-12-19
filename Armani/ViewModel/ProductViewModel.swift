//
//  ProductViewModel.swift
//  Armani
//
//  Created by Samahir Adi on 18/12/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import Foundation

class ProductViewModel {
    
    static var shared = ProductViewModel()
    
    var productArray: [ProductElement]?
 
    func getProducts(completion: @escaping () -> ()) {
        Service.shared.getProductElement(callback: { (element) in
            self.productArray = element
            print("=====")
            print(element)
            completion()
        })
    }
    
}

