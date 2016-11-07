import Foundation
import SwiftyJSON

public struct Timestamp: JSONType {

    let epoch: Double
    public static func fromJSON(_ json: JSON?) throws -> Timestamp {
        
        guard let json = json else {
            throw ValidationError.missingValue
        }
        
        guard let timestampString = json.string else {
            throw ValidationError.read(message: "value is not a string")
        }
        
        //TODO: Not so nice
        let iso8601Formatter = DateFormatter()
        iso8601Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        iso8601Formatter.timeZone = TimeZone(secondsFromGMT: 0)
        iso8601Formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
        iso8601Formatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = iso8601Formatter.date(from: timestampString) else {
            throw ValidationError.invalid(message: "´\(timestampString)´ is not a valid ISO 8601 timestamp")
        }
        
        return Timestamp(epoch: date.timeIntervalSince1970)
    }
    
    public init(epoch: Double) {
        self.epoch = epoch
    }
        
    public static func ==(lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.epoch == rhs.epoch
    }
    
    public func toJSON() -> JSON {
        
        //TODO: Not so nice
        let iso8601Formatter = DateFormatter()
        iso8601Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        iso8601Formatter.timeZone = TimeZone(secondsFromGMT: 0)
        iso8601Formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
        iso8601Formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let date = Date(timeIntervalSince1970: epoch)
        let timestampString = iso8601Formatter.string(from: date) + "Z"
        
        return JSON(timestampString)

    }
    
}
