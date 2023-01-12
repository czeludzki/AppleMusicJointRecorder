//
//  RecordVM.swift
//  ApM Expense Caculator
//
//  Created by siuzeontou on 11/1/2023.
//

import Foundation

class RecordVM: ObservableObject {
    enum Operation {
        case save
        case delete
    }
    
    enum Status {
        case idel
    }
    
    weak var vm: VM?
    
    init(_ dealRecord: DealRecord? = nil, member: Member, vm: VM? = nil) {
        self.vm = vm
        self.dealRecord = dealRecord ?? DealRecord.init(member: member)
    }
    
    @Published var dealRecord: DealRecord
    
    func operationHandling(_ operation: MemberVM.Operation) {
        switch operation {
        case .save:
            try? self.vm?.saveDealRecord(self.dealRecord)
        case .delete:
            break
        }
    }
}
