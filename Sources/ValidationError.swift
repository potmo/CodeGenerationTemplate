import Foundation
import SwiftyJSON

indirect enum ValidationError: Swift.Error {
    case missingValue
    case wrongType
    case read(message: String)
    case invalid(message: String)
    case upstreamError(field: String, error: ValidationError)
    
    public func getString(_ fields: [String] = []) -> String {
        switch self {
        case .missingValue: return fields.joined(separator: ".") + " -> missing value"
        case .read(let message): return fields.joined(separator: ".") + " -> failed reading: \(message)"
        case .invalid(let message): return fields.joined(separator: ".") + " -> failed validating: \(message)"
        case .wrongType: return fields.joined(separator: ".") + " -> unexpected type"
        case .upstreamError(let field, let error):
            return error.getString(fields + [field])
        }
    }
}
