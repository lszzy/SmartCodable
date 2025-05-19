//
//  Ignore.swift
//

import Foundation

// MARK: - DefaultCaseCodable
public protocol DefaultCaseCodable: RawRepresentable, Codable {
    static var defaultCase: Self { get }
}

extension DefaultCaseCodable where Self.RawValue: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(RawValue.self)
        self = Self(rawValue: rawValue) ?? Self.defaultCase
    }
}

// MARK: - BasicType
public protocol BasicType {
    init()
}

extension Int: BasicType {}
extension Int8: BasicType {}
extension Int16: BasicType {}
extension Int32: BasicType {}
extension Int64: BasicType {}
extension UInt: BasicType {}
extension UInt8: BasicType {}
extension UInt16: BasicType {}
extension UInt32: BasicType {}
extension UInt64: BasicType {}
extension Bool: BasicType {}
extension Float: BasicType {}
extension Double: BasicType {}
extension Data: BasicType {}
extension Date: BasicType {}
extension String: BasicType {}
extension Array: BasicType {}
extension Set: BasicType {}
extension Dictionary: BasicType {}
extension Decimal: BasicType {}
extension CGFloat: BasicType {}
extension URL: BasicType {
    public init() { self = (NSURL(string: "") ?? NSURL()) as URL }
}

// MARK: - SmartModelConfiguration
public class SmartModelConfiguration: @unchecked Sendable {
    public static let shared = SmartModelConfiguration()
    
    public var decodingOptions: Set<SmartDecodingOption>? = nil
    public var encodingOptions: Set<SmartEncodingOption>? = nil
}

// MARK: - SmartDecodable
extension SmartDecodable {
    public static func deserializeAny(from object: Any?, designatedPath: String? = nil, options: Set<SmartDecodingOption>? = nil) -> Self? {
        if let dict = object as? [String: Any] {
            return deserialize(from: dict, designatedPath: designatedPath, options: options)
        } else if let data = object as? Data {
            return deserialize(from: data, designatedPath: designatedPath, options: options)
        } else {
            return deserialize(from: object as? String, designatedPath: designatedPath, options: options)
        }
    }
}

extension Array where Element: SmartDecodable {
    public static func deserializeAny(from object: Any?, designatedPath: String? = nil, options: Set<SmartDecodingOption>? = nil) -> [Element]? {
        if let array = object as? [Any] {
            return deserialize(from: array, designatedPath: designatedPath, options: options)
        } else if let data = object as? Data {
            return deserialize(from: data, designatedPath: designatedPath, options: options)
        } else {
            return deserialize(from: object as? String, designatedPath: designatedPath, options: options)
        }
    }
}

extension SmartDecodable where Self: SmartEncodable {
    public mutating func mergeAny(from object: Any?, designatedPath: String? = nil) {
        if let dict = object as? [String: Any] {
            SmartUpdater.update(&self, from: dict)
        } else if let data = object as? Data {
            SmartUpdater.update(&self, from: data)
        } else {
            SmartUpdater.update(&self, from: object as? String)
        }
    }
}
