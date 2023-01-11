//
//  CommonViews.swift
//  ApM Expense Caculator
//
//  Created by siu on 2022/10/16.
//

import SwiftUI

struct Row<LeadingContent, TrailingContent>: View where LeadingContent: View, TrailingContent: View {
    var leadingContent: () -> LeadingContent
    var trailingContent: () -> TrailingContent
    var body: some View {
        HStack {
            leadingContent()
            Spacer()
            trailingContent()
        }.contentShape(Rectangle())
    }
}

struct TextFieldClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            content
            
            if !text.isEmpty {
                Button(
                    action: { self.text = "" },
                    label: {
                        Image(systemName: "delete.left")
                            .foregroundColor(Color(UIColor.opaqueSeparator))
                    }
                )
            }
        }
    }
}

struct DealRecordCell: View {
    var dealRecord: DealRecord
    
    var body: some View {
        VStack(alignment: .leading) {
            Row {
                Text(self.dealRecord.product.name).foregroundColor(.gray)
            } trailingContent: {
                Text(self.dealRecord.totalPrice_str).foregroundColor(.gray)
            }
            Row {
                Text("Count:").foregroundColor(.gray)
            } trailingContent: {
                Text(String(self.dealRecord.numOfProduct)).foregroundColor(.gray)
            }
            Row {
                Text("DealStartDate:").foregroundColor(.gray)
            } trailingContent: {
                Text(self.dealRecord.dealStartDate.HKDOLL.string(with: "yyyy-MM-dd")).foregroundColor(.gray)
            }
            Row {
                Text("DealEndDate:").foregroundColor(.gray)
            } trailingContent: {
                Text(self.dealRecord.dealEndDate?.HKDOLL.string(with: "yyyy-MM-dd") ?? "Date invalid").foregroundColor(.gray)
            }
            Row {
                Text("Total Price:").foregroundColor(.gray)
            } trailingContent: {
                Text(self.dealRecord.totalPrice_str).foregroundColor(.gray)
            }
        }
    }
}

struct CommonViews_Previews: PreviewProvider {
    static var previews: some View {
        Row {
            Text("Title").font(.system(size: 18, weight: .bold))
        } trailingContent: {
            Text("Title").font(.system(size: 12, weight: .regular))
        }

    }
}
