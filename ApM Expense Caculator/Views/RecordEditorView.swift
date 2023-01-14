//
//  RecordEditorView.swift
//  ApM Expense Caculator
//
//  Created by siuzeontou on 11/1/2023.
//

import SwiftUI

struct RecordEditorView: View {
    
    @EnvironmentObject var vm: VM
    @ObservedObject var recordVM: RecordVM
    @Environment(\.dismiss) var productEditorViewDismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Row {
                        Text("Creation Date:").foregroundColor(.gray)
                    } trailingContent: {
                        Text(self.recordVM.dealRecord.creationDate.HKDOLL.string(with: "yyyy/MM/dd-hh:mm")).foregroundColor(.gray)
                    }
                    Row {
                        VStack(alignment: .leading) {
                            Text("Deal Start Date")
                        }
                    } trailingContent: {
                        DatePicker.init("", selection: self.$recordVM.dealRecord.dealStartDate, displayedComponents: [.date])
                    }
                    Row {
                        Text("Deal End Date")
                    } trailingContent: {
                        Text.init(self.recordVM.dealRecord.dealEndDate?.ISO8601Format(.iso8601) ?? "")
                    }
                } footer: {
                    Text(self.recordVM.dealRecord.id).font(.subheadline).foregroundColor(.gray).multilineTextAlignment(.center)
                }
                Section {
                    if let product = self.$recordVM.dealRecord.product {
                        ProductListView.ProductCell.init(product: product)
                    } else {
                        Text("Select a Product")
                    }
                } header: {
                    HStack {
                        Text("Product")
                        Spacer()
                        Button("Select Product") {
                            
                        }
                    }
                }
                Section {
                    Row {
                        Text("Quantity")
                    } trailingContent: {
                        Picker.init(selection: self.$recordVM.dealRecord.numOfProduct) {
                            ForEach(1...30, id: \.self) {
                                Text($0.description)
                            }
                        } label: {}.pickerStyle(.menu)
                    }
                    Row {
                        Text("Custom Price")
                    } trailingContent: {
                        TextField.init("Type Custom Price Here", value: self.$recordVM.dealRecord.customPrice, formatter: NumberFormatter()).multilineTextAlignment(.trailing).foregroundColor(.gray).keyboardType(.decimalPad)
                    }
                } footer: {
                    Text("Price: \(self.recordVM.dealRecord.totalPrice_str)")
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarTitle(Text("Deal Record"))
            .navigationBarItems(leading: Button(action: {
                // 关闭
                self.productEditorViewDismiss.callAsFunction()
            }, label: {
                Image(systemName: "xmark")
            }), trailing: Button(action: {
                // 保存
                self.recordVM.operationHandling(.save)
                self.productEditorViewDismiss.callAsFunction()
            }, label: {
                Text("Save")
            }))
        }
    }
}

//struct RecordEditorView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordEditorView.init(recordVM: RecordVM.init(member: ??))
//    }
//}
