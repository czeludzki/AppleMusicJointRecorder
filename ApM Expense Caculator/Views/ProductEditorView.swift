//
//  ProductEditorView.swift
//  ApM Expense Caculator
//
//  Created by siu on 2022/10/16.
//

import SwiftUI

struct ProductEditorView: View {
    
    @EnvironmentObject var vm: VM
    @ObservedObject var productVM: ProductVM
    @Environment(\.dismiss) var productEditorViewDismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Row {
                        Text("Name:").foregroundColor(.gray)
                    } trailingContent: {
                        TextField("Type Product Name here", text: self.$productVM.product.name).multilineTextAlignment(.trailing).foregroundColor(.gray)
                    }
                    Row {
                        VStack(alignment: .leading) {
                            Text("Number Of Period")
                            Text("Combine more than one same period as a new period").foregroundColor(.gray).font(.system(size: 12)).multilineTextAlignment(.leading)
                        }
                    } trailingContent: {
                        Picker.init(selection: self.$productVM.product.numOfPeriod) {
                            ForEach(1...30, id: \.self) {
                                Text($0.description)
                            }
                        } label: {}.pickerStyle(.menu)
                    }
                    Row {
                        Text("Period")
                    } trailingContent: {
                        Picker.init(selection: self.$productVM.product.period) {
                            ForEach(Period.allCases, id: \.self) {
                                Text($0.description)
                            }
                        } label: {}.pickerStyle(.menu)
                    }
                    Row {
                        Text("Price")
                    } trailingContent: {
                        TextField.init("Type Price Here", value: self.$productVM.product.price, formatter: NumberFormatter()).multilineTextAlignment(.trailing).foregroundColor(.gray).keyboardType(.decimalPad)
                    }
                } footer: {
                    Text(self.productVM.product.id).font(.subheadline).foregroundColor(.gray).multilineTextAlignment(.center)
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarTitle(Text("Product"))
            .navigationBarItems(leading: Button(action: {
                // 关闭
                self.productEditorViewDismiss.callAsFunction()
            }, label: {
                Image(systemName: "xmark")
            }), trailing: Button(action: {
                // 保存
                self.productVM.operationHandling(.save)
                self.productEditorViewDismiss.callAsFunction()
            }, label: {
                Text("Save")
            }))
        }
    }
}

struct ProductEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ProductEditorView(productVM: ProductVM.init())
    }
}
