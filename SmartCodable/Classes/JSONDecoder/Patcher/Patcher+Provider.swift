//
//  ValuePatcher.swift
//  SmartCodable
//
//  Created by Mccc on 2023/8/22.
//

import Foundation



extension Patcher {
    struct Provider {
        static func defaultValue() throws -> T {
            if let value = T.self as? BasicType.Type {
                return value.init() as! T
            }
            
            // 处理 SmartDecodable 类型的对象
            if let decodable = T.self as? SmartDecodable.Type {
                return decodable.init() as! T
            }
            
            // 处理 SmartCaseDefaultable 类型的对象
            if let caseDefaultable = T.self as? any SmartCaseDefaultable.Type {
                if let firstCase = caseDefaultable.allCases.first as? T {
                    return firstCase
                }
            }
            
            // ***处理 DefaultCaseCodable 类型的对象***
            if let caseCodable = T.self as? any DefaultCaseCodable.Type {
                return caseCodable.defaultCase as! T
            }
            
            // 处理 SmartAssociatedEnumerable 类型的对象
            if let associatedEnumerable = T.self as? any SmartAssociatedEnumerable.Type {
                return associatedEnumerable.defaultCase as! T
            }
            
            // 如果都没有匹配的类型，抛出错误
            throw DecodingError.valueNotFound(T.self, DecodingError.Context(codingPath: [], debugDescription: "Expected \(T.self) value，but an exception occurred！Please report this issue（请上报该问题）"))
        }
    }
}
