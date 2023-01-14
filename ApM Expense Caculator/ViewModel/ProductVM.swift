//
//  ProductVM.swift
//  ApM Expense Caculator
//
//  Created by siuzeontou on 19/10/2022.
//

import Foundation

class ProductVM: ObservableObject {
    
    enum Operation {
        case save
        case delete
    }
    
    enum Status {
        case idel
    }
        
    init(_ product: Product? = nil) {
        self.product = product ?? Product.init()
    }
    
    @Published var product: Product
    
    func operationHandling(_ operation: ProductVM.Operation) {
        switch operation {
        case .save:
            try? VM.share.saveProduct(self.product)
        case .delete:
            break
        }
    }
}
