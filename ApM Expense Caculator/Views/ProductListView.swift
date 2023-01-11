//
//  ProductListView.swift
//  ApM Expense Caculator
//
//  Created by siu on 2022/10/16.
//

import SwiftUI

struct ProductListView: View {
    
    @EnvironmentObject var vm: VM
    @State var selectedProduct: Product?
    
    var body: some View {
        List {
            ForEach(self.$vm.products, id: \.self) { product in
                ProductCell(product: product).onTapGesture {
                    self.selectedProduct = product.wrappedValue
                }.fullScreenCover(item: self.$selectedProduct) { selectedProduct in
                    ProductEditorView.init(productVM: ProductVM.init(selectedProduct, vm: self.vm))
                }
            }
        }
    }
}

struct ProductCell: View {
    
    @Binding var product: Product
    
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

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
//        ProductCell(product: Product.init(name: "月付", numOfPeriod: 1, period: .month, price: 15))
        ProductListView()
    }
}
