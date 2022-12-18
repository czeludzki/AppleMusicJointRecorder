//
//  Mod.swift
//  ApM Expense Caculator
//
//  Created by siu on 2022/10/15.
//

import Foundation

enum Period: Int, CaseIterable {
    case day
    case week
    case month
    case year
    
    var dateComponent: Calendar.Component {
        switch self {
        case .day:
            return .day
        case .week:
            return .weekday
        case .month:
            return .month
        case .year:
            return .year
        }
    }
    
    var description: String {
        switch self {
        case .day:
            return "day"
        case .week:
            return "week"
        case .month:
            return "month"
        case .year:
            return "year"
        }
    }
}

class Product: HandyJSON, Hashable {
    
    static func == (lhs: Product, rhs: Product) -> Bool { lhs.id == rhs.id }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id.hashValue)
    }
    
    let id = UUID().uuidString
    var name: String = ""
    // 周期数量.
    // 即允许用户设计一个为期半年(6个月)的商品. 此值可设置为 6, period = .month
    // 同理也可让用户设计一个为期4周的商品. 此值可设置为 4, period = .week
    var numOfPeriod: Int = 2
    // 商品有效周期
    var period: Period = .month
    // 价格
    var price: Double = 0
    
    var periodDescription: String {
        return String(self.numOfPeriod) + "✖️" + self.period.description
    }
    
    required init() {}
    
    init(name: String, numOfPeriod: Int, period: Period, price: Double) {
        self.name = name
        self.numOfPeriod = numOfPeriod
        self.period = period
        self.price = price
    }
}

struct Remark {
    var k: String
    var v: String
}

class DealRecord: HandyJSON, Hashable {
    
    required init() {}
    
    static func == (lhs: DealRecord, rhs: DealRecord) -> Bool { lhs.id == rhs.id }
    
    func hash(into hasher: inout Hasher) { hasher.combine(self.id.hashValue) }
    
    let id: String = UUID().uuidString
    // 创建日期
    var date: Date = Date()
    // 交易生效日期
    var dealStartDate: Date = Date()
    // 产品
    var product: Product = Product()
    // 购买量
    var numOfProduct: Int = 0
    // 如果此值非空, 则价格计算方式为 直接取 customPrice
    // 如果此值为空, 则价格计算方式为 product.price * numOfProduct
    var customPrice: Double?
    var remarks: [Remark] = []
    
    // MARK: Caculate
    // 本次交易的到期日期
    var dealEndDate: Date? {
        guard let res = self.dealStartDate.HKDOLL.dateByAdding(values: self.numOfProduct * self.product.numOfPeriod, for: self.product.period.dateComponent), res > self.dealStartDate else {
            return nil
        }
        return res
    }
    
    // 用于展示的 price
    var totalPrice_str: String {
        if let customPrice = self.customPrice {
            return String.init(format: "%.2f", customPrice)
        }else{
            return String.init(format: "%.2f", product.price * Double(numOfProduct))
        }
    }
}

enum MemberStatus: Int {
    // 新建状态. 没有任何记录.
    case initial
    // 正常态
    case normal
    // 过期了
    case expire
    // 该member主动下车. 不再有关系了. 也不能对这种状态的 member 进行续费操作(添加 record 操作). 该类型的member只剩下留底的意义了.
    case quit
}

class Member: HandyJSON, Hashable {
    
    required init() {}
    
    static func == (lhs: Member, rhs: Member) -> Bool { lhs.id == rhs.id }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id.hashValue)
    }
    
    var name: String = ""
    let id: String = UUID().uuidString
    var joinDate: Date = Date()
    var memberStatus: MemberStatus = .initial
    var remarks: [Remark] = []
    var records: [DealRecord] = []
    
    // 续期
    func renewal(dealRecord: DealRecord) {
        self.records.append(dealRecord)
        // 更新通知
        self.upgradeNotification()
    }
    
    func upgradeNotification() {
        
    }
}


// MARK: Store
extension Collection where Element == Product {
    
    func store() {
        let jsonStr = self.toJSONString()
        
    }
}
