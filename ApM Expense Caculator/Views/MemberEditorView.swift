//
//  MemberEditorView.swift
//  ApM Expense Caculator
//
//  Created by siu on 2022/10/16.
//

import SwiftUI

struct MemberEditorView: View {
    
    @Binding var member: Member
    
    var body: some View {
        List {
            Section {
                Row {
                    Text("Name:").foregroundColor(.gray)
                } trailingContent: {
                    TextField("Type User Name here", text: self.$member.name).multilineTextAlignment(.trailing).modifier(TextFieldClearButton.init(text: self.$member.name))
                }
                DatePicker.init("Join Date", selection: self.$member.joinDate, displayedComponents: [.date])
            } footer: {
                Text(self.member.id).font(.subheadline).foregroundColor(.gray).multilineTextAlignment(.center)
            }
            Section.init {
                ForEach(self.member.records, id: \.self) { record in
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
    }
}

struct MemberEditorView_Previews: PreviewProvider {
    static var previews: some View {
        MemberEditorView(member: Binding<Member>.init(get: {
            Member.init()
        }, set: { _ in
            
        }))
    }
}
