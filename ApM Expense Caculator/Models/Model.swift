//
//  Mod.swift
//  ApM Expense Caculator
//
//  Created by siu on 2022/10/15.
//

import Foundation

enum Period: Int, CaseIterable, Codable {
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

class Product: Codable, Hashable, Identifiable, ObservableObject {
    
    static func == (lhs: Product, rhs: Product) -> Bool { lhs.id == rhs.id }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id.hashValue)
    }
    
    let id: String
    @Published var name: String = ""
    // 周期数量.
    // 即允许用户设计一个为期半年(6个月)的商品. 此值可设置为 6, period = .month
    // 同理也可让用户设计一个为期4周的商品. 此值可设置为 4, period = .week
    @Published var numOfPeriod: Int = 2
    // 商品有效周期
    @Published var period: Period = .month
    // 价格
    @Published var price: Double = 0
    
    var periodDescription: String {
        return String(self.numOfPeriod) + "✖️" + self.period.description
    }
    
    required init(from decoder: Decoder) throws {
        self.id = try decoder.decode("id")
        self.name = (try? decoder.decode("name")) ?? ""
        self.numOfPeriod = (try? decoder.decode("numOfPeriod")) ?? 0
        self.period = (try? decoder.decode("period")) ?? .month
        self.price = (try? decoder.decode("price")) ?? 0
    }
    
    func encode(to encoder: Encoder) throws {
        try encoder.encode(self.id, for: "id")
        try encoder.encode(self.name, for: "name")
        try encoder.encode(self.numOfPeriod, for: "numOfPeriod")
        try encoder.encode(self.period, for: "period")
        try encoder.encode(self.price, for: "price")
    }
    
    init(name: String, numOfPeriod: Int, period: Period, price: Double) {
        self.id = UUID.init().uuidString
        self.name = name
        self.numOfPeriod = numOfPeriod
        self.period = period
        self.price = price
    }
    
    init() {
        self.id = UUID.init().uuidString
    }
}

struct Remark: Codable, Hashable {
    var k: String
    var v: String
}

class DealRecord: Codable, Hashable, Identifiable {
    
    required init(from decoder: Decoder) throws {
        self.id = try decoder.decode("id")
        self.creationDate = try decoder.decode("creationDate", using: ISO8601DateFormatter.init())
        self.dealStartDate = try decoder.decode("dealStartDate", using: ISO8601DateFormatter.init())
        self.product = try decoder.decode("product")
        self.numOfProduct = try decoder.decode("numOfProduct")
        self.customPrice = try? decoder.decode("customPrice")
        self.remarks = try decoder.decode("remarks", as: [Remark].self)
    }
    
    func encode(to encoder: Encoder) throws {
        try encoder.encode(self.id, for: "id")
        try encoder.encode(self.creationDate, for: "creationDate", using: ISO8601DateFormatter.init())
        try encoder.encode(self.dealStartDate, for: "dealStartDate", using: ISO8601DateFormatter.init())
        try encoder.encode(self.product, for: "product")
        try encoder.encode(self.numOfProduct, for: "numOfProduct")
        try encoder.encode(self.customPrice, for: "customPrice")
        try encoder.encode(self.remarks, for: "remarks")
    }
    
    init(member: Member) {
        self.id = UUID().uuidString
        self.member = member
    }
    
    static func == (lhs: DealRecord, rhs: DealRecord) -> Bool { lhs.id == rhs.id }
    
    func hash(into hasher: inout Hasher) { hasher.combine(self.id.hashValue) }
    
    let id: String
    // 用户
    weak var member: Member?
    // 创建日期
    @Published var creationDate: Date = Date()
    // 交易生效日期
    @Published var dealStartDate: Date = Date()
    // 产品
    @Published var product: Product = Product()
    // 购买量
    @Published var numOfProduct: Int = 0
    // 如果此值非空, 则价格计算方式为 直接取 customPrice
    // 如果此值为空, 则价格计算方式为 product.price * numOfProduct
    @Published var customPrice: Double?
    @Published var remarks: [Remark] = []
    
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
        }
        return String.init(format: "%.2f", product.price * Double(numOfProduct))
    }
}

extension Member {
    enum Status: Int, Codable, CaseIterable {
        // 新建状态. 没有任何记录.
        case initial
        // 正常态
        case normal
        // 过期了
        case expire
        // 该member主动下车. 不再有关系了. 也不能对这种状态的 member 进行续费操作(添加 record 操作). 该类型的member只剩下留底的意义了.
        case quit
    }
}

class Member: Codable, Hashable, Identifiable {
    
    required init(from decoder: Decoder) throws {
        self.id = try decoder.decode("id")
        self.name = try decoder.decode("name")
        self.joinDate = try decoder.decode("joinDate", using: ISO8601DateFormatter.init())
        self.memberStatus = try decoder.decode("memberStatus")
        self.remarks = try decoder.decode("remarks")
        self.records = try decoder.decode("records")
        
        self.records.forEach {
            $0.member = self
        }
    }
    
    func encode(to encoder: Encoder) throws {
        try encoder.encode(self.id, for: "id")
        try encoder.encode(self.name, for: "name")
        try encoder.encode(self.joinDate, for: "joinDate", using: ISO8601DateFormatter.init())
        try encoder.encode(self.memberStatus, for: "memberStatus")
        try encoder.encode(self.remarks, for: "remarks")
        try encoder.encode(self.records, for: "records")
    }
    
    init() {
        self.id = UUID.init().uuidString
    }
    
    static func == (lhs: Member, rhs: Member) -> Bool { lhs.id == rhs.id }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id.hashValue)
    }
    
    let id: String
    var name: String = ""
    var joinDate: Date = Date()
    var memberStatus: Member.Status = .initial
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
extension Array where Element == Product {
    func store() throws {
        let data = try self.encoded()
        let jsonStr = String.init(data: data, encoding: .utf8)
        do {
            try jsonStr?.write(to: VM.productInfoFileURL, atomically: true, encoding: .utf8)
        } catch let err {
            print("保存 Product 失败了", err)
        }
    }
}

extension Array where Element == Member {
    func store() throws {
        let data = try self.encoded()
        let jsonStr = String.init(data: data, encoding: .utf8)
        do {
            try jsonStr?.write(to: VM.memberInfoFileURL, atomically: true, encoding: .utf8)
        } catch let err {
            print("保存 Member 失败了", err)
        }
    }
}
