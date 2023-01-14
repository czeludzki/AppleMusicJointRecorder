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
    
    init(_ dealRecord: DealRecord) {
        self.dealRecord = dealRecord
    }
    
    @Published var dealRecord: DealRecord
    
    func operationHandling(_ operation: MemberVM.Operation) {
        switch operation {
        case .save:
            try? VM.share.saveDealRecord(self.dealRecord)
        case .delete:
            break
        }
    }
}
