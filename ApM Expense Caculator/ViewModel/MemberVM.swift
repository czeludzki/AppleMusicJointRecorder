//
//  MemberVM.swift
//  ApM Expense Caculator
//
//  Created by siuzeontou on 21/12/2022.
//

import Foundation

class MemberVM: ObservableObject {
    enum Operation {
        case save
        case delete
    }
    
    enum Status {
        case idel
    }
        
    init(_ member: Member? = nil) {
        self.member = member ?? Member.init()
    }
    
    @Published var member: Member
    
    func operationHandling(_ operation: MemberVM.Operation) {
        switch operation {
        case .save:
            try? VM.share.saveMember(self.member)
        case .delete:
            break
        }
    }
}
