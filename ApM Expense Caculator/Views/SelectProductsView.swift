//
//  SelectProductsView.swift
//  ApM Expense Caculator
//
//  Created by siuzeontou on 14/1/2023.
//

import SwiftUI

struct SelectProductsView: View {
    
    @EnvironmentObject var vm: VM
    
    var body: some View {
        List {
            ForEach(self.vm.products) { product in
                ProductCell.init(product: product)
            }
        }
    }
}

extension SelectProductsView {
    struct ProductCell: View {
        let product: Product
        var body: some View {
            VStack {
                Row {
                    Text(self.product.name).font(.title)
                } trailingContent: {
                    VStack(alignment: .trailing) {
                        Text(self.product.periodDescription).foregroundColor(Color.gray)
                        Text(String.init(format: "%.2f", self.product.price)).foregroundColor(Color.gray)
                    }
                }
            }
        }
    }
}

struct SelectProductsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectProductsView()
    }
}
