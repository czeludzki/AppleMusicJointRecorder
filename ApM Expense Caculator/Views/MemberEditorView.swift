//
//  MemberEditorView.swift
//  ApM Expense Caculator
//
//  Created by siu on 2022/10/16.
//

import SwiftUI

struct MemberEditorView: View {
    
    @EnvironmentObject var vm: VM
    @ObservedObject var memberVM: MemberVM
    @Environment(\.dismiss) var memberEditorViewDismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Row {
                        Text("Name:").foregroundColor(.gray)
                    } trailingContent: {
                        TextField("Type User Name here", text: self.$memberVM.member.name).multilineTextAlignment(.trailing).modifier(TextFieldClearButton.init(text: self.$memberVM.member.name))
                    }
                    DatePicker.init("Join Date", selection: self.$memberVM.member.joinDate, displayedComponents: [.date])
                } footer: {
                    Text(self.memberVM.member.id).font(.subheadline).foregroundColor(.gray).multilineTextAlignment(.center)
                }
                Section.init {
                    ForEach(self.memberVM.member.records, id: \.self) { record in
                        DealRecordCell(dealRecord: record)
                    }
                } header: {
                    Row {
                        Text("Deal Record")
                    } trailingContent: {
                        Button("Add Record") {
                            
                        }
                    }
                }
                Section.init {
                    ForEach(["1","2","3","4"], id: \.self) { identifiable in
                        Row {
                            Text(identifiable)
                        } trailingContent: {
                            Text(identifiable)
                        }
                    }
                } header: {
                    Row {
                        Text("Remark")
                    } trailingContent: {
                        Button("Add Remark") {
                            
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Member"))
            .navigationBarItems(leading: Button(action: {
                // 关闭
                self.memberEditorViewDismiss.callAsFunction()
            }, label: {
                Image(systemName: "xmark")
            }), trailing: Button(action: {
                // 保存
                self.memberVM.operationHandling(.save)
                self.memberEditorViewDismiss.callAsFunction()
            }, label: {
                Text("Save")
            }))
        }
    }
}

struct MemberEditorView_Previews: PreviewProvider {
    static var previews: some View {
        MemberEditorView.init(memberVM: MemberVM.init())
    }
}
