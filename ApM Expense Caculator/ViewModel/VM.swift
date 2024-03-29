//
//  VM.swift
//  ApM Expense Caculator
//
//  Created by siu on 2022/10/15.
//

import Foundation

class VM: ObservableObject {
    
    static let share: VM = VM()
    
    static let memberInfoFileName = "members.json"
    static let productInfoFileName = "products.json"
    
    static var productInfoFileURL: URL { Self.dataStoreFolder.appendingPathExtension(Self.productInfoFileName) }
    static var memberInfoFileURL: URL { Self.dataStoreFolder.appendingPathExtension(Self.memberInfoFileName) }
    
    static let dataStoreFolder: URL = {
        guard let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { fatalError("Can't access sandbox folder 'Documents'") }
        return URL.init(fileURLWithPath: documentDir).appendingPathComponent("/DataStore")
    }()
    
    // 尝试创建数据目录
    func createDataStoreFolderIfNeed() throws {
        try FileManager.default.createDirectory(at: Self.dataStoreFolder, withIntermediateDirectories: true)
    }
    
    var anyCancellabel: Set<AnyCancellable> = []
    
    private init() {
        do {
            try self.createDataStoreFolderIfNeed()
        } catch let err as NSError {
            fatalError("createDataStoreFolderIfNeed err: \(err.localizedDescription), code: \(err.code)")
        }
        // TODO: 更新 Member 状态: 过期状态
        // 分组
        self.$allMembers.debounce(for: 0.5, scheduler: DispatchQueue.main).throttle(for: 0.5, scheduler: DispatchQueue.main, latest: true).sink { [weak self] allMembers in
            self?.initialMembers = allMembers.filter({ $0.memberStatus == .initial }).sorted(by: {
                guard let m0_endDate = $0.records.first?.dealEndDate, let m1_endDate = $1.records.first?.dealEndDate else { return true }
                return m0_endDate > m1_endDate
            })
            self?.expiredMembers = allMembers.filter({ $0.memberStatus == .expire }).sorted(by: {
                guard let m0_endDate = $0.records.first?.dealEndDate, let m1_endDate = $1.records.first?.dealEndDate else { return true }
                return m0_endDate > m1_endDate
            })
            self?.normalMembers = allMembers.filter({ $0.memberStatus == .normal }).sorted(by: {
                if let m0_endDate = $0.records.first?.dealEndDate, let m1_endDate = $1.records.first?.dealEndDate {
                    return m0_endDate > m1_endDate
                }else{
                    return $0.memberStatus.rawValue < $1.memberStatus.rawValue
                }
            })
            self?.quitedMembers = allMembers.filter({ $0.memberStatus == .quit }).sorted(by: {
                guard let m0_endDate = $0.records.first?.dealEndDate, let m1_endDate = $1.records.first?.dealEndDate else { return true }
                return m0_endDate < m1_endDate
            })
        }.store(in: &self.anyCancellabel)
    }
    
    @Published private var allMembers: [Member] = {
        guard let res = (try? String.init(contentsOf: VM.memberInfoFileURL))?.data(using: .utf8) else {
            return []
        }
        do {
            return try JSONDecoder().decode([Member].self, from: res)
        } catch let err {
            fatalError(err.localizedDescription)
        }
    }()
    
    @Published var initialMembers: [Member] = []
    @Published var expiredMembers: [Member] = []
    @Published var normalMembers: [Member] = []
    @Published var quitedMembers: [Member] = []
    
    @Published var products: [Product] = {
        guard let res = (try? String.init(contentsOf: VM.productInfoFileURL))?.data(using: .utf8) else {
            return []
        }
        do {
            return try JSONDecoder().decode([Product].self, from: res)
        } catch let err {
            fatalError(err.localizedDescription)
        }
    }()
    
    // 加载所有数据
    func loadData() {
        let enumerator = FileManager.default.enumerator(at: Self.dataStoreFolder, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants, .skipsPackageDescendants])
        while let folder = enumerator?.nextObject(), let folder = folder as? URL {
            let memberInfoFile = folder.appendingPathComponent(Self.memberInfoFileName, conformingTo: .text)
            guard let memberInfoJson = try? String.init(contentsOfFile: memberInfoFile.path, encoding: .utf8).data(using: .utf8) else {
                print("\(self) loadData() try? String.init(contentsOfFile: memberInfoFile.path, encoding: .utf8) 出错")
                continue
            }
            guard let member = try? memberInfoJson.decoded(as: Member.self) else {
                print("\(self) loadData() Member.deserialize(from: memberInfoJsonString) 失败")
                continue
            }
            self.allMembers.append(member)
        }
    }
    
    func memberQuit(_ member: Member) {
        member.memberStatus = .quit
        try? self.saveMember(member)
    }
    
    // 保存 Member
    func saveMember(_ newMember: Member) throws {
        // 如果已经存在, 就先移除旧的
        if let member = self.allMembers.filter({ $0.id == newMember.id }).first {
            self.allMembers.removeAll { $0.id == member.id }
        }
        self.allMembers.insert(newMember, at: 0)
        // 持久化
        self.storeData(Member.self)
    }
    
    // 保存 Product
    func saveProduct(_ newProduct: Product) throws {
        // 如果已经存在, 就先移除旧的
        if let product = self.products.filter({ $0.id == newProduct.id }).first {
            self.products.removeAll { $0.id == product.id }
        }
        self.products.insert(newProduct, at: 0)
        // 持久化
        self.storeData(Product.self)
    }
    
    func saveDealRecord(_ record: DealRecord) throws {
        // 将 record 保存到 某个 member
        guard let member = self.allMembers.filter({ $0.id == record.member?.id }).first else { throw NSError.init(domain: "Member not exist", code: 1) }
        if let targetRecord = member.records.filter({ $0.id == record.id }).first {
            member.records.removeAll { $0.id == targetRecord.id }
        }
        member.records.insert(record, at: 0)
        // 持久化
        self.storeData(Member.self)
    }
    
    func storeData(_ dataType: Any.Type) {
        if dataType is Product.Type {
            try? self.products.store()
        }
        if dataType is Member.Type {
            try? self.allMembers.store()
        }
    }
}
