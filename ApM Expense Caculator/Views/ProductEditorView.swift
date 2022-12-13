//
//  ProductEditorView.swift
//  ApM Expense Caculator
//
//  Created by siu on 2022/10/16.
//

import SwiftUI

struct ProductEditorView: View {
    
    @EnvironmentObject var vm: VM
    @Binding var product: Product
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Row {
                        Text("Name:").foregroundColor(.gray)
                    } trailingContent: {
                        TextField("Type Product Name here", text: self.$product.name).multilineTextAlignment(.trailing).foregroundColor(.gray)
                    }
                    Row {
                        VStack(alignment: .leading) {
                            Text("Number Of Period")
                            Text("Combine more than one same period as a new period").foregroundColor(.gray).font(.system(size: 12)).multilineTextAlignment(.leading)
                        }
                    } trailingContent: {
                        Picker.init(selection: self.$product.numOfPeriod) {
                            ForEach(1...30, id: \.self) {
                                Text($0.description)
                            }
                        } label: {}.pickerStyle(.menu)
                    }
                    Row {
                        Text("Period")
                    } trailingContent: {
                        Picker.init(selection: self.$product.period) {
                            ForEach(Period.allCases, id: \.self) {
                                Text($0.description)
                            }
                        } label: {}.pickerStyle(.menu)
                    }

                    Row {
                        Text("Price")
                    } trailingContent: {
                        TextField.init("Type Price Here", value: self.$product.price, formatter: NumberFormatter()).multilineTextAlignment(.trailing).foregroundColor(.gray).keyboardType(.decimalPad)
                    }

                } footer: {
                    Text(self.product.id).font(.subheadline).foregroundColor(.gray).multilineTextAlignment(.center)
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarTitle(Text("Product"))
            .navigationBarItems(leading: Button(action: {
                self.dismiss.callAsFunction()
            }, label: {
                Image(systemName: "xmark")
            }), trailing: Button(action: {
                self.vm.saveProduct(self.product)
                self.dismiss.callAsFunction()
            }, label: {
                Text("Save")
            }))
        }
    }
}

struct ProductEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ProductEditorView(product: Binding<Product>.init(get: {
            Product.init(name: "月付", numOfPeriod: 1, period: .month, price: 15)
        }, set: { _ in
            
        }))
    }
}
