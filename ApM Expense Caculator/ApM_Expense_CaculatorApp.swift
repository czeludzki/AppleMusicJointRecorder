//
//  ApM_Expense_CaculatorApp.swift
//  ApM Expense Caculator
//
//  Created by siu on 2022/10/15.
//

import SwiftUI
@_exported import HandyJSON
@_exported import SwiftyJSON
@_exported import Combine

@main
struct ApM_Expense_CaculatorApp: App {
    
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(VM())
        }
    }
}
