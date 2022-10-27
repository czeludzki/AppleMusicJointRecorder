//
//  ProductVM.swift
//  ApM Expense Caculator
//
//  Created by siuzeontou on 19/10/2022.
//

import Foundation

class ProductVM: ObservableObject {
    
    enum Operation {
        case new(product: Product)
        case save(product: Product)
        case delete(productID: String)
    }
    
    @Published var product: Product = Product()
    
    var operationPublisher: Combine.PassthroughSubject = Combine.PassthroughSubject<Operation, Never>()
}
