//
//  ProductVM.swift
//  ApM Expense Caculator
//
//  Created by siuzeontou on 19/10/2022.
//

import SwiftUI
import Foundation

class ProductVM: ObservableObject {
    
    enum Operation {
        case save
        case delete
    }
    
    enum Status {
        case idel
    }
    
    @EnvironmentObject var vm: VM
    
    init(_ product: Product? = nil) {
        self.product = product ?? Product.init()
    }
    
    @Published var product: Product
    
    func operationHandling(_ operation: ProductVM.Operation) {
        switch operation {
        case .save:
            break
        case .delete:
            break
        }
    }
}
