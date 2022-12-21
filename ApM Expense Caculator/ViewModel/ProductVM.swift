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
    
    weak var vm: VM?
    
    init(_ product: Product? = nil, vm: VM? = nil) {
        self.vm = vm
        self.product = product ?? Product.init()
    }
    
    @Published var product: Product
    
    func operationHandling(_ operation: ProductVM.Operation) {
        switch operation {
        case .save:
            try? self.vm?.saveProduct(self.product)
        case .delete:
            break
        }
    }
}
