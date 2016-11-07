import Foundation
import SwiftyJSON

public protocol JSONType: Equatable {
    func toJSON() -> JSON
    static func fromJSON(_ json: JSON?) throws -> Self
}

