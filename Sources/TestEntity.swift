
/* json to parse
 
 {
 "required_string": "test",
 "optional_string": "test",
 "required_int": 123,
 "optional_int": 123,
 "required_bool": true,
 "optional_bool": true,
 "required_timestamp": "2016-09-30T17:18:19.000Z",
 "optional_timestamp": "2016-09-30T17:18:19.000Z",
 "required_example_enum": "first",
 "optional_example_enum": "first",
 "required_example_class": {
 "required_string": "test"
 "optional_int": 123
 },
 "optional_example_class": {
 "required_string": "test"
 "optional_int": 123
 },
 "required_array": ["a", "b", "c"],
 "optional_array": ["a", "b", "c"]
 }
 */

/* swagger
 
 {
 "/some/path/with/{id}/etc": {
 "get": {
 "description": "Returns example entity",
 "produces": [
 "application/json"
 ],
 "parameters": [
 {
 "name": "id",
 "in": "path",
 "description": "ID of the entity",
 "required": true,
 "type": "string"
 }
 ],
 "responses": {
 "200": {
 "description": "An example entiry",
 "schema": {
 "type": "array",
 "items": {
 "$ref": "#/definitions/pet"
 }
 }
 }
 }
 }
 }
 }
 
 */


import SwiftyJSON //https://github.com/lingoer/SwiftyJSON
//import Alamofire //https://github.com/Alamofire/Alamofire
/// Example API
/// Example API Description
/// Version 0.0.1
public struct ExampleAPI {
    /*
    private let sessionManager: SessionManager
    public init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }*/
    /*
    /// GET https://example.domain.com/some/path/with/{id}/etc
    public func getExampleEntity(withId id: String, callback: (result: Result<ExampleEntity>) -> Void ) -> Void {
        
        // Remember to url encode the id
        let url = "https://www.example.domain.com/some/path/with/\(id)/etc"
        let exampleEntity = ...
            callback(.Success(exampleEntity))
        
        // authentication is added to the session manager instead of here
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        // could be added for ?a=1&b=2
        let parameters: Parameters = [
            "foo": "bar"
        ]
        
        
        // This is another option instead of the inlined in `request`
        //let url = URL(string: "https://www.example.domain.com")!.appendingPathComponent("/some/path/with/\(id)/etc")
        //var urlRequest = URLRequest(url: url)
        //urlRequest.httpMethod = "GET"
        //urlRequest.httpBody = entity.toJSONString()
        //urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //let encodedUrlRequest = try! URLEncoding.queryString.encode(urlRequest, with: parameters)
        //.request(encodedUrlRequest)
        
        self.sessionManager
            .request(url, headers: headers, parameters: parameters, encoding: URLEncoding.default, method: .get)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    if let entity = ExampleEntry(json) {
                        callback(Result<ExampleEntry>.success(entiry))
                    } else {
                        callback(Result<ExampleEntry>.failure(BackendError.jsonSerialization(error: "some message"))
                    }
                case .failure(let error):
                    callback(Result<ExampleEntry>.failure(error))
                }
        }
    }
 */
    
    public struct ExampleEntity: JSONType {
        
        /// A required String
        public let requiredString: String
        
        /// An optional String
        public let optionalString: String?
        
        /// A required Int
        public let requiredInt: Int
        
        /// An optional Int
        public let optionalInt: Int?
        
        /// A required Bool
        public let requiredBool: Bool
        
        /// An optional Bool
        public let optionalBool: Bool?
        
        /// A required Timestamp
        public let requiredTimestamp: Timestamp
        
        /// An optional Timestamp
        public let optionalTimestamp: Timestamp?
        
        /// A required ExampleEnum
        public let requiredEnum: ExampleEnum
        
        /// An optional ExampleEnum
        public let optionalEnum: ExampleEnum?
        
        /// A required ExampleClass
        public let requiredClass: ExampleClass
        
        /// An optional ExampleClass
        public let optionalClass: ExampleClass?
        
        // A required Array<String>
        public let requiredArray: [String]
        
        // An optional Array<String>
        public let optionalArray: [String]?
        
        // An optional Array<String?>?
        public let  optionalOptionalArray:[String?]?
        
        // An required Array<String?>
        public let  requiredOptionalArray:[String?]
        
        public static func fromJSON(_ json: JSON?) throws -> ExampleEntity {
            
            guard let json = json else { throw ValidationError.missingValue }
            
            guard let _ = json.dictionaryObject else {
                throw ValidationError.read(message: "expected object got something else")
            }
            
            let requiredString: String
            let optionalString: String?
            let requiredInt: Int
            let optionalInt: Int?
            let requiredBool: Bool
            let optionalBool: Bool?
            let requiredTimestamp: Timestamp
            let optionalTimestamp: Timestamp?
            let requiredEnum: ExampleEnum
            let optionalEnum: ExampleEnum?
            let requiredClass: ExampleClass
            let optionalClass: ExampleClass?
            let requiredArray: [String]
            let optionalArray: [String]?
            let optionalOptionalArray: [String?]?
            let requiredOptionalArray: [String?]
            
            do{
                requiredString = try String.fromJSON(json["required_string"])
            } catch let error as ValidationError {
                throw ValidationError.upstreamError(field: "required_string", error: error)
            }
            
            do{
                optionalString = try String.fromJSON(json["optional_string"])
            } catch {
                optionalString = nil
            }
            
            do{
                requiredInt = try Int.fromJSON(json["required_int"])
            } catch let error as ValidationError {
                throw ValidationError.upstreamError(field: "required_int", error: error)
            }
            
            do {
                optionalInt = try Int.fromJSON(json["optional_int"])
            } catch {
                optionalInt = nil
            }
            
            do{
                requiredBool = try Bool.fromJSON(json["required_bool"])
            } catch let error as ValidationError {
                throw ValidationError.upstreamError(field: "required_bool", error: error)
            }
            
            do{
                optionalBool = try Bool.fromJSON(json["optional_bool"])
            } catch {
                optionalBool = nil
            }
            
            do{
                requiredTimestamp = try  Timestamp.fromJSON(json["required_timestamp"])
            } catch let error as ValidationError {
                throw ValidationError.upstreamError(field: "required_timestamp", error: error)
            }
            
            do{
                optionalTimestamp = try Timestamp.fromJSON(json["optional_timestamp"])
            } catch {
                optionalTimestamp = nil
            }
            
            do{
                requiredEnum = try ExampleEnum.fromJSON(json["required_enum"])
            } catch let error as ValidationError{
                throw ValidationError.upstreamError(field: "required_enum", error: error)
            }
            
            do{
                optionalEnum = try ExampleEnum.fromJSON(json["optional_enum"])
            } catch {
                optionalEnum = nil
            }
            
            do{
                requiredClass = try ExampleClass.fromJSON(json["required_class"])
            } catch let error as ValidationError{
                throw ValidationError.upstreamError(field: "required_class", error: error)
            }
            
            do{
                optionalClass = try ExampleClass.fromJSON(json["optional_class"])
            } catch {
                optionalClass = nil
            }
            
            do{
                requiredArray = try Array.fromJSON(json["required_array"])
            } catch let error as ValidationError{
                throw ValidationError.upstreamError(field: "required_array", error: error)
            }
            
            do {
                optionalArray = try Array.fromJSON(json["optional_array"])
            } catch {
                optionalArray = nil
            }
            
            do{
                optionalOptionalArray = try Array.fromJSON(json["optional_optional_array"])
            } catch {
                optionalOptionalArray = nil
            }
            
            do{
                requiredOptionalArray = try Array.fromJSON(json["required_optional_array"])
            } catch let error as ValidationError{
                throw ValidationError.upstreamError(field: "required_optional_array", error: error)
            }
            
            
            return ExampleEntity(requiredString: requiredString,
                                 optionalString: optionalString,
                                 requiredInt: requiredInt,
                                 optionalInt: optionalInt,
                                 requiredBool: requiredBool,
                                 optionalBool: optionalBool,
                                 requiedTimestamp: requiredTimestamp,
                                 optionalTimestamp: optionalTimestamp,
                                 requiredEnum: requiredEnum,
                                 optionalEnum: optionalEnum,
                                 requiredClass: requiredClass,
                                 optionalClass: optionalClass,
                                 requiredArray: requiredArray,
                                 optionalArray: optionalArray,
                                 optionalOptionalArray: optionalOptionalArray,
                                 requiredOptionalArray: requiredOptionalArray)
        }
        
        init(requiredString: String,
             optionalString: String?,
             requiredInt: Int,
             optionalInt: Int?,
             requiredBool: Bool,
             optionalBool: Bool?,
             requiedTimestamp: Timestamp,
             optionalTimestamp: Timestamp?,
             requiredEnum: ExampleEnum,
             optionalEnum: ExampleEnum?,
             requiredClass: ExampleClass,
             optionalClass: ExampleClass?,
             requiredArray: [String],
             optionalArray: [String]?,
             optionalOptionalArray: [String?]?,
             requiredOptionalArray: [String?]) {
            
            self.requiredString = requiredString
            self.optionalString = optionalString
            self.requiredInt = requiredInt
            self.optionalInt = optionalInt
            self.requiredBool = requiredBool
            self.optionalBool = optionalBool
            self.requiredTimestamp = requiedTimestamp
            self.optionalTimestamp = optionalTimestamp
            self.requiredEnum = requiredEnum
            self.optionalEnum = optionalEnum
            self.requiredClass = requiredClass
            self.optionalClass = optionalClass
            self.requiredArray = requiredArray
            self.optionalArray = optionalArray
            self.optionalOptionalArray = optionalOptionalArray
            self.requiredOptionalArray = requiredOptionalArray
        }
        
        public func toJSON() -> JSON {
            var json: JSON = [:]
            
            json["required_string"] = JSON(requiredString)
            if let optionalString = optionalString { json["optional_string"] = optionalString.toJSON() }
            json["required_int"] = JSON(requiredInt)
            if let optionalInt = optionalInt { json["optional_int"] = optionalInt.toJSON() }
            json["required_bool"] = JSON(requiredBool)
            if let optionalBool = optionalBool { json["optional_bool"] = optionalBool.toJSON() }
            json["required_timestamp"] = requiredTimestamp.toJSON()
            if let optionalTimestamp = optionalTimestamp { json["optional_timestamp"] = optionalTimestamp.toJSON() }
            json["required_example_enum"] = requiredEnum.toJSON()
            if let optionalEnum = optionalEnum { json["optional_example_enum"] = optionalEnum.toJSON() }
            json["required_example_class"] = requiredClass.toJSON()
            if let optionalClass = optionalClass { json["optional_example_class"] = optionalClass.toJSON() }
            json["required_array"] = requiredArray.flatMap{ $0 }.toJSON()
            if let optionalArray = optionalArray { json["optional_array"] = optionalArray.flatMap{ $0 }.toJSON() }
            json["required_optional_array"] = requiredOptionalArray.flatMap{ $0 }.toJSON()
            if let optionalOptionalArray = optionalOptionalArray { json["optional_optional_array"] = optionalOptionalArray.flatMap{ $0 }.toJSON() }
            
            return json
        }
        
        // Equatable implementation
        static public func ==(a: ExampleEntity, b: ExampleEntity) -> Bool {
            return
                a.requiredString == b.requiredString &&
                a.optionalString == b.optionalString &&
                a.requiredInt == b.requiredInt &&
                a.optionalInt == b.optionalInt &&
                a.requiredBool == b.requiredBool &&
                a.optionalBool == b.optionalBool &&
                a.requiredTimestamp == b.requiredTimestamp &&
                a.optionalTimestamp == b.optionalTimestamp &&
                a.requiredEnum == b.requiredEnum &&
                a.optionalEnum == b.optionalEnum &&
                a.requiredClass == b.requiredClass &&
                a.optionalClass == b.optionalClass &&
                a.requiredArray == b.requiredArray &&
                a.optionalArray == b.optionalArray &&
                a.optionalOptionalArray == b.optionalOptionalArray &&
                a.requiredOptionalArray == b.requiredOptionalArray
        }
        
        
        /// Some description of the class
        public enum ExampleEnum: String, JSONType {
            // Must be Equatable and CustomStringConvertible. Gets that from string
            case first = "first"
            case second = "second"
            
            public static func fromJSON(_ json: JSON?) throws -> ExampleEnum {
                guard let json = json else { throw ValidationError.missingValue}
                guard let string = json.string else { throw ValidationError.read(message: json.error?.description ?? "could not read string" )}
                guard let result = ExampleEnum(rawValue: string) else {
                    throw ValidationError.read(message: "enum value is not one of possible values")
                }
                return result
            }
            
            public func toJSON() -> JSON {
                return JSON(self.rawValue)
            }
            
            public static func ==(lhs: ExampleEnum, rhs: ExampleEnum) -> Bool {
                return lhs.rawValue == rhs.rawValue
            }
        }
        
        public struct ExampleClass: JSONType {
            public let requiredString: String
            public let optionalInt: Int?
            
            public static func fromJSON(_ json: JSON?) throws -> ExampleClass {
                guard let json = json else { throw ValidationError.missingValue}
                
                guard let _ = json.dictionaryObject else {
                    throw ValidationError.read(message: "expected object got something else")
                }
                
                let requiredString: String
                let optionalInt: Int?
                
                do {
                    requiredString = try String.fromJSON(json["required_string"])
                } catch let error as ValidationError{
                    throw ValidationError.upstreamError(field: "required_string", error: error)
                }
                
                do {
                    optionalInt = try Int.fromJSON(json["optional_int"])
                } catch _ {
                    optionalInt = nil
                }
                
                return ExampleClass(requiredString: requiredString, optionalInt: optionalInt)
            }
            
            public init(requiredString:String, optionalInt: Int?) {
                self.requiredString = requiredString
                self.optionalInt = optionalInt
            }
            
            public func toJSON() -> JSON {
                var json: JSON = [:]

                json["required_string"] = self.requiredString.toJSON()
                if let optionalInt = optionalInt {
                    json["optional_int"] = optionalInt.toJSON()
                }
                
                return json
            }
                        
            public static func ==(lhs: ExampleClass, rhs: ExampleClass) -> Bool {
                return lhs.requiredString == rhs.requiredString &&
                       lhs.optionalInt == rhs.optionalInt
            }
            
            
        }
    }
}
