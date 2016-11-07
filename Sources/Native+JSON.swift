import SwiftyJSON
import Foundation

public extension Sequence where Iterator.Element: JSONType {
    public static func fromJSON(_ json: JSON?) throws -> [Iterator.Element] {
        guard let json = json else {
            throw ValidationError.missingValue
        }
        
        guard let array = json.array else {
            throw ValidationError.read(message: "value is not an array")
        }
        
        var tempArray: [Iterator.Element] = []
        for (index, subJson) in array.enumerated() {
            
            do {
                let instance = try Iterator.Element.fromJSON(subJson)
                tempArray.append(instance)
            } catch let error as ValidationError {
                throw ValidationError.upstreamError(field: "[\(index)]", error: error)
            }
            
        }
        return tempArray
    }
    
    public static func fromJSON(_ json: JSON?) throws -> [Iterator.Element?] {
        guard let json = json else {
            throw ValidationError.missingValue
        }
        
        guard let array = json.array else {
            throw ValidationError.read(message: "value is not an array")
        }
        
        var tempArray: [Iterator.Element?] = []
        for subJson in array {
            do {
                let instance = try Iterator.Element.fromJSON(subJson)
                tempArray.append(instance)
            } catch {
                // discard element
            }
        }
        return tempArray
    }

}


public extension Sequence where Iterator.Element: JSONType {
    func toJSON() -> JSON {
        return JSON( self.map{ $0.toJSON() })
    }
}

/*
public extension Array {
    public static func toJSON<T:JSONType>(_ object: [T]) -> JSON  {
        return JSON(object.map{ e in e.toJSON()})
    }
    
    public static func toJSON<T:JSONType>(_ object: [T]?) -> JSON  {
        guard let object = object else { return JSON.null }
        return JSON(object.map{ e in e.toJSON()})
    }
    
    public static func toJSON<T:JSONType>(_ object: [T?]) -> JSON  {
        let jsonArray:[JSON] = object.map{
            guard let e = $0 else {
                return JSON.null
            }
            return e.toJSON()
        }
        return JSON(jsonArray)
    }
    
    public static func toJSON<T:JSONType>(_ object: [T?]?) -> JSON  {
        guard let object = object else { return JSON.null }
        let jsonArray:[JSON] = object.map{
            guard let e = $0 else {
                return JSON.null
            }
            return e.toJSON()
        }
        return JSON(jsonArray)
    }
}
 */


extension String: JSONType {

    public static func fromJSON(_ json: JSON?) throws -> String {
        guard let json = json else {
            throw ValidationError.missingValue
        }
        
        guard let string = json.string else {
            throw ValidationError.read(message: "value is not a string")
        }
        return string
    }
    
    public func toJSON() -> JSON {
        return JSON(self)
    }
}

extension Int: JSONType {
    public static func fromJSON(_ json: JSON?) throws -> Int {
        guard let json = json else {
            throw ValidationError.missingValue
        }

        guard let int = json.int else {
            throw ValidationError.read(message: "value is not an integer")
        }
        return int
    }
    
    public func toJSON() -> JSON {
        return JSON(self)
    }
}


extension Bool: JSONType {
    public static func fromJSON(_ json: JSON?) throws -> Bool {
        guard let json = json else {
            throw ValidationError.missingValue
        }

        guard let bool = json.bool else {
            throw ValidationError.read(message: "value is not a boolean")
        }
        return bool
    }
    
    public func toJSON() -> JSON {
        return JSON(self)
    }
}

public func ==<T: JSONType>(lhs: [T?], rhs: [T?]) -> Bool {
    if lhs.count != rhs.count { return false }
    for (l,r) in zip(lhs,rhs) {
        if l != r { return false }
    }
    return true
}

public func ==<T: JSONType>(lhs: [T]?, rhs: [T]?) -> Bool {
    
        switch (lhs,rhs) {
        case (.some(let lhs), .some(let rhs)):
            return lhs == rhs
        case (.none, .none):
            return true
        default:
            return false
        }
}

public func ==<T: JSONType>(lhs: [T?]?, rhs: [T?]?) -> Bool {
    
    switch (lhs,rhs) {
    case (.some(let lhs), .some(let rhs)):
        return lhs == rhs
    case (.none, .none):
        return true
    default:
        return false
    }
}


