//
//  ProductViewModel.swift
//  Armani
//
//  Created by Michael Martinez on 18/12/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import Foundation

class ProductViewModel {

  static var shared = ProductViewModel()
  
  var productArray: [ProductElement]?
  
    var product: Product?
    
  func getProducts(completion: @escaping () -> ()) {
    Service.shared.getProductElement(callback: { (element) in
        self.productArray = element
        print("=====")
        print(element)
        completion()
    })
      }
    
    func getProd(completion: @escaping () -> ()) {
    Service.shared.getProduct(callback: { (element) in
        self.product = element
        print("=====")
        print(element)
        completion()
    })
      }
    
    
  }

