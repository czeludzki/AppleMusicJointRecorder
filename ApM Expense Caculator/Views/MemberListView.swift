//
//  MemberListView.swift
//  ApM Expense Caculator
//
//  Created by siu on 2022/10/16.
//

import SwiftUI

struct MemberListView: View {
    
    @EnvironmentObject var vm: VM
    @State var selectedMember: Member?
    
    var body: some View {
        List {
            Section("Expired") {
                ForEach(self.$vm.expiredMembers, id: \.self) { m in
                    MemberCell(member: m).onTapGesture {
                        self.selectedMember = m.wrappedValue
                    }.fullScreenCover(item: self.$selectedMember) { m in
                        MemberEditorView.init(memberVM: MemberVM.init(m))
                    }
                }
            }
            Section("Initial") {
                ForEach(self.$vm.initialMembers, id: \.self) { m in
                    MemberCell(member: m).onTapGesture {
                        self.selectedMember = m.wrappedValue
                    }.fullScreenCover(item: self.$selectedMember) { m in
                        MemberEditorView.init(memberVM: MemberVM.init(m))
                    }
                }
            }
            Section("Normal") {
                ForEach(self.$vm.normalMembers, id: \.self) { m in
                    MemberCell(member: m).onTapGesture {
                        self.selectedMember = m.wrappedValue
                    }.fullScreenCover(item: self.$selectedMember) { m in
                        MemberEditorView.init(memberVM: MemberVM.init(m))
                    }
                }
            }
            Section("Exited") {
                ForEach(self.$vm.quitedMembers, id: \.self) { m in
                    MemberCell(member: m).onTapGesture {
                        self.selectedMember = m.wrappedValue
                    }.fullScreenCover(item: self.$selectedMember) { m in
                        MemberEditorView.init(memberVM: MemberVM.init(m))
                    }
                }
            }
        }
    }
}

struct MemberCell: View {
    
    @EnvironmentObject var vm: VM
    @Binding var member: Member
    @State var isLatestDealRecordFold: Bool = false
    @State var isRecordEditorViewPresent = false
    
    var body: some View {
        VStack {
            Row {
                Text(self.member.name).font(.title2)
            } trailingContent: {
                HStack {
                    Circle().frame(width: 12).foregroundColor(.red)
                }
            }
            Divider()
            
            Row {
                Text("Join Date:")
            } trailingContent: {
                Text(self.member.joinDate.HKDOLL.string(with: "yyyy-MM-dd")).foregroundColor(.gray)
            }
            Divider()
            
            VStack(alignment: .leading) {
                Row {
                    Text("Latest Deal Record:")
                } trailingContent: {
                    HStack {
                        if self.member.records.count == 0 {
                            Text("None")
                        }else{
                            Text(self.member.records.first!.dealStartDate.HKDOLL.string(with: "yyyy-MM-dd")).foregroundColor(.gray)
                            if self.isLatestDealRecordFold {
                                Image(systemName: "chevron.down").foregroundColor(.blue)
                            }else{
                                Image(systemName: "chevron.right").foregroundColor(.blue)
                            }
                        }
                    }
                }.frame(height: 32).onTapGesture {
                    self.isLatestDealRecordFold.toggle()
                }
                if self.member.records.first != nil && self.isLatestDealRecordFold {
                    DealRecordCell(dealRecord: self.member.records.first!).padding(.vertical, 4).padding(.horizontal, 6).background(Color.init(.systemYellow).opacity(0.5)).cornerRadius(12)
                }
            }
        }
        .padding()
        .contextMenu {
            Button.init("Renew") {
                self.isRecordEditorViewPresent.toggle()
            }
            if self.member.memberStatus != .quit {
                Button.init("Quit") {
                    self.vm.memberQuit(self.member)
                }
            }
        }.fullScreenCover(isPresented: self.$isRecordEditorViewPresent) {
            RecordEditorView.init(recordVM: .init(DealRecord.init(member: self.member)))
        }
    }
}

struct MemberListView_Previews: PreviewProvider {
    static var previews: some View {
        MemberListView()
    }
}
