//
//  Date+.swift
//  iCareFone
//
//  Created by siuzeontou on 19/5/2022.
//

import Foundation

protocol NameSpaceWrappable {
    associatedtype WrappedType
    var HKDOLL: WrappedType { get }
    static var HKDOLL: WrappedType.Type { get }
}

extension NameSpaceWrappable {
    var HKDOLL: NameSpaceWrapper<Self> { NameSpaceWrapper.init(wrappedValue: self) }
    static var HKDOLL: NameSpaceWrapper<Self>.Type { NameSpaceWrapper.self }
}

public protocol TypeWrapperProtocol {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
}

struct NameSpaceWrapper<T>: TypeWrapperProtocol {
    var wrappedValue: T
}

extension Date: NameSpaceWrappable {}
extension TypeWrapperProtocol where WrappedType == Date {
    
    private static var calendar: Calendar { Calendar.current }
    
    var year: Int {
        Self.calendar.dateComponents(Set<Calendar.Component>.init([.year]), from: self.wrappedValue).year ?? 0
    }
    
    var month: Int {
        Self.calendar.dateComponents(Set<Calendar.Component>.init([.month]), from: self.wrappedValue).month ?? 0
    }
    
    var day: Int {
        Self.calendar.dateComponents(Set<Calendar.Component>.init([.day]), from: self.wrappedValue).day ?? 0
    }
    
    var weekDay: Int {
        Self.calendar.dateComponents(Set<Calendar.Component>.init([.weekday]), from: self.wrappedValue).weekday ?? 0
    }
    
    var hour: Int {
        Self.calendar.dateComponents(Set<Calendar.Component>.init([.hour]), from: self.wrappedValue).hour ?? 0
    }
    
    var minute: Int {
        Self.calendar.dateComponents(Set<Calendar.Component>.init([.minute]), from: self.wrappedValue).minute ?? 0
    }
    
    var second: Int {
        Self.calendar.dateComponents(Set<Calendar.Component>.init([.second]), from: self.wrappedValue).second ?? 0
    }
    
    var numberOfDaysInMonth: Int {
        Self.calendar.range(of: .day, in: .month, for: self.wrappedValue)?.count ?? 0
    }
    
    func string(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self.wrappedValue)
    }
    
    func dateByAdding(values: Int, for component: Calendar.Component) -> Date? {
        var components = DateComponents.init()
        components.setValue(values, for: component)
        return Self.calendar.date(byAdding: components, to: self.wrappedValue)
    }
    
    func dateBySubtracting(values: Int, for component: Calendar.Component) -> Date? {
        self.dateByAdding(values: values, for: component)
    }
    
    /// 计算两个日期之间某单位的差值, 例如年月日
    func from(other: Date, component: Calendar.Component) -> Int? {
        let components = Self.calendar.dateComponents(Set<Calendar.Component>.init([component]), from: other, to: self.wrappedValue)
        return components.value(for: component)
    }
    
    func isSameDay(other: Date?) -> Bool {
        guard let other = other else { return false }
        return self.year == other.HKDOLL.year && self.month == other.HKDOLL.month && self.day == other.HKDOLL.day
    }
    
    func isSameMonth(other: Date?) -> Bool {
        guard let other = other else { return false }
        return self.year == other.HKDOLL.year && self.month == other.HKDOLL.month
    }
    
    static var today: Date {
        let now = Date()
        return Date.init(year: now.HKDOLL.year, month: now.HKDOLL.month, day: now.HKDOLL.day)!
    }
}

extension Date {
    
    init?(from string: String, format: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        guard let date = formatter.date(from: string) else { return nil }
        self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
    init?(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        guard let date = Calendar.current.date(from: components) else { return nil }
        self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
}
