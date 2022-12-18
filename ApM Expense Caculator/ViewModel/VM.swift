//
//  VM.swift
//  ApM Expense Caculator
//
//  Created by siu on 2022/10/15.
//

import Foundation

class VM: ObservableObject {
    
    static let memberInfoFileName = "data.json"
    
    static let dataStoreFolder: URL = {
        guard let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            fatalError("Can't access sandbox folder 'Documents'")
        }
        return URL.init(fileURLWithPath: documentDir).appendingPathComponent("/DataStore")
    }()
    
    // 尝试创建数据目录
    func createDataStoreFolderIfNeed() throws {
        try FileManager.default.createDirectory(at: Self.dataStoreFolder, withIntermediateDirectories: true)
    }
    
    var anyCancellabel: Set<AnyCancellable> = []
    
    init() {
        do {
            try self.createDataStoreFolderIfNeed()
        } catch let err as NSError {
            fatalError("createDataStoreFolderIfNeed err: \(err.localizedDescription), code: \(err.code)")
        }
        // TODO: 更新 Member 状态: 过期状态
        // 分组
        self.$allMembers.debounce(for: 0.1, scheduler: DispatchQueue.main).throttle(for: 0.1, scheduler: DispatchQueue.main, latest: true).sink { [weak self] allMembers in
            self?.expiredMembers = allMembers.filter({ $0.memberStatus == .expire }).sorted(by: {
                guard let m0_endDate = $0.records.first?.dealEndDate, let m1_endDate = $1.records.first?.dealEndDate else { return true }
                return m0_endDate > m1_endDate
            })
            self?.normalMembers = allMembers.filter({ $0.memberStatus == .normal || $0.memberStatus == .initial }).sorted(by: {
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
    
    @Published private var allMembers: [Member] = []
    @Published var expiredMembers: [Member] = []
    @Published var normalMembers: [Member] = []
    @Published var quitedMembers: [Member] = []
    
    @Published var products: [Product] = []
    
    // 加载所有数据
    func loadData() {
        let enumerator = FileManager.default.enumerator(at: Self.dataStoreFolder, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants, .skipsPackageDescendants])
        while let folder = enumerator?.nextObject(), let folder = folder as? URL {
            let memberInfoFile = folder.appendingPathComponent(Self.memberInfoFileName, conformingTo: .text)
            guard let memberInfoJsonString = try? String.init(contentsOfFile: memberInfoFile.path, encoding: .utf8) else {
                print("\(self) loadData() try? String.init(contentsOfFile: memberInfoFile.path, encoding: .utf8) 出错")
                continue
            }
            guard let member = Member.deserialize(from: memberInfoJsonString) else {
                print("\(self) loadData() Member.deserialize(from: memberInfoJsonString) 失败")
                continue
            }
            self.allMembers.append(member)
        }
    }
    
    // 保存 Member
    func saveMember(_ member: Member) throws {
        
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
    
    func storeData(_ dataType: Any.Type) {
        
    }
}
