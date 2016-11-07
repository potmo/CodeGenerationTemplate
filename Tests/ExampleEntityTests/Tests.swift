//
//  Tests.swift
//  Tests
//
//  Created by Nisse Bergman on 2016-11-06.
//
//

import XCTest
@testable import CodeGen
import SwiftyJSON


enum TestEnum: String, CodeGen.JSONType {
    
    case one = "one"
    case two = "two"
    
    func toJSON() -> JSON {
        return JSON(self.rawValue)
    }
    static func fromJSON(_ json: JSON?) throws -> TestEnum {
        guard let json = json else {
            throw ValidationError.missingValue
        }
       
        guard let string = json.string else {
            throw ValidationError.read(message: "value is not a string")
        }
        
        guard let e = self.init(rawValue: string) else {
            throw ValidationError.invalid(message: "`\(string)` is not a valid enum value")
        }
        
        return e
    }
    
    public static func ==(lhs: TestEnum, rhs: TestEnum) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

struct TestStructWithRequiredEnum: CodeGen.JSONType {
    
    let enumValue: TestEnum
    
    init(enumValue: TestEnum){
        self.enumValue = enumValue
    }
    
    func toJSON() -> JSON {
        var json: JSON = [:]
        json["enum"] = enumValue.toJSON()
        return json
    }
    
    static func fromJSON(_ json: JSON?) throws -> TestStructWithRequiredEnum {
        guard let json = json else {
            throw ValidationError.missingValue
        }
        
        guard let _ = json.dictionaryObject else {
            throw ValidationError.read(message: "expected object got something else")
        }
        
        let enumValue: TestEnum
        do {
            enumValue = try TestEnum.fromJSON(json["enum"])
        } catch let error as ValidationError {
            throw ValidationError.upstreamError(field: "enum", error: error)
        }
        return self.init(enumValue: enumValue)
    }
    
    public static func ==(lhs: TestStructWithRequiredEnum, rhs: TestStructWithRequiredEnum) -> Bool {
        return lhs.enumValue == rhs.enumValue
    }
}

struct TestStructWithOptionalEnum: CodeGen.JSONType {
    
    let enumValue: TestEnum?
    
    init(enumValue: TestEnum?){
        self.enumValue = enumValue
    }
    
    func toJSON() -> JSON {
        var json: JSON = [:]
        if let enumValue = enumValue { json["enum"] = enumValue.toJSON() }
        return json
    }
    
    static func fromJSON(_ json: JSON?) throws -> TestStructWithOptionalEnum {
        
        guard let json = json else {
            throw ValidationError.missingValue
        }
        
        guard let _ = json.dictionaryObject else {
            throw ValidationError.read(message: "value is not an object")
        }
        
        let enumValue: TestEnum?
        do {
            enumValue = try TestEnum.fromJSON(json["enum"])
        } catch {
            enumValue = nil
        }
        return self.init(enumValue: enumValue)
    }
    
    public static func ==(lhs: TestStructWithOptionalEnum, rhs: TestStructWithOptionalEnum) -> Bool {
        return lhs.enumValue == rhs.enumValue
    }
}

struct TestStructWithRequiredArray: CodeGen.JSONType {
    
    let array: [TestEnum]
    
    init(array: [TestEnum]){
        self.array = array
    }
    
    func toJSON() -> JSON {
        var json: JSON = [:]
        json["array"] = array.flatMap{$0}.toJSON()
        return json
    }
    
    static func fromJSON(_ json: JSON?) throws -> TestStructWithRequiredArray {
        
        guard let json = json else {
            throw ValidationError.missingValue
        }
        
        guard let _ = json.dictionaryObject else {
            throw ValidationError.read(message: "value is not an object")
        }
        
        let array: [TestEnum]
        do {
            array = try Array.fromJSON(json["array"])
        } catch let error as ValidationError {
             throw ValidationError.upstreamError(field: "array", error: error)
        }
        return self.init(array: array)
    }
    
    public static func ==(lhs: TestStructWithRequiredArray, rhs: TestStructWithRequiredArray) -> Bool {
        return lhs.array == rhs.array
    }
}

func backAndFourth<T: JSONType>(_ input: T) throws -> T {
    let jsonString = input.toJSON().description
    let json = JSON.parse(jsonString)
    return try T.fromJSON(json)
}

func parseString<T: JSONType>(_ jsonString: String, to type: T.Type) throws -> T {
    let json = JSON.parse(jsonString)
    return try T.fromJSON(json)
}

func backAndFourth<T: JSONType>(_ jsonString: String, to type: T.Type) throws -> String {
    let json = JSON.parse(jsonString)
    let entity = try T.fromJSON(json)
    return entity.toJSON().description
}

func printError(error: Error) -> Void {
    print("got expected exception: \((error as? ValidationError)?.getString() ?? "unknown" )")
}

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Class With Required Enum
    
    func testClassWithRequiredEnumSet() {
        let string = "{\"enum\": \"one\"}"
        
        let result = try? parseString(string, to: TestStructWithRequiredEnum.self)
        
        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.enumValue)
        XCTAssertEqual(result?.enumValue, .one)
    }
    
    func testClassWithRequiredEnumMissing() {
        let string = "{}"
        XCTAssertThrowsError( try parseString(string, to: TestStructWithRequiredEnum.self), "expeced to throw", printError)
    }
    
    func testClassWithRequiredEnumInvalid() {
        let string = "{\"enum\": \"invalid\"}"
        XCTAssertThrowsError( try parseString(string, to: TestStructWithRequiredEnum.self), "expeced to throw", printError)
    }
    
    func testClassWithRequiredEnumWithEmptyJson() {
        let string = ""
        XCTAssertThrowsError( try parseString(string, to: TestStructWithRequiredEnum.self), "expeced to throw", printError)
    }
    
    // MARK: Class With Optional Enum
    
    func testClassWithOptionalEnumSet() {
        let string = "{\"enum\": \"one\"}"
        let result = try? parseString(string, to: TestStructWithOptionalEnum.self)
        
        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.enumValue)
        XCTAssertEqual(result?.enumValue, .one)
    }
    
    func testClassWithOptionalEnumInvalid() {
        let string = "{\"enum\": \"invalid\"}"
        let result = try? parseString(string, to: TestStructWithOptionalEnum.self)
        
        XCTAssertNotNil(result)
        XCTAssertNil(result?.enumValue)
    }
    
    func testClassWithOptionalEnumMissing() {
        let string = "{}"
        let result = try? parseString(string, to: TestStructWithOptionalEnum.self)
        
        XCTAssertNotNil(result)
        XCTAssertNil(result?.enumValue)
    }
    
    func testClassWithOptionalEnumWithEmptyJSON() {
        let string = ""
        XCTAssertThrowsError( try parseString(string, to: TestStructWithOptionalEnum.self), "expeced to throw", printError)
    }
    
    // MARK: Class With Required Array

    func testClassWithRequiredArraySet() {
        let string = "{\"array\": [\"one\", \"two\", \"one\"] }"
        let result = try? parseString(string, to: TestStructWithRequiredArray.self)
        
        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.array)
        XCTAssertEqual(result?.array.count, 3)
        XCTAssertEqual(result?.array[0], .one)
        XCTAssertEqual(result?.array[1], .two)
        XCTAssertEqual(result?.array[2], .one)
    }
    
    func testClassWithRequiredArraySetButEmpty() {
        let string = "{\"array\": [] }"
        let result = try? parseString(string, to: TestStructWithRequiredArray.self)
        
        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.array)
        XCTAssertEqual(result?.array.count, 0)
    }
    
    func testClassWithRequiredArrayMissing() {
        let string = "{}"
        XCTAssertThrowsError( try parseString(string, to: TestStructWithRequiredArray.self), "expeced to throw", printError)
    }
    
    func testClassWithRequiredArrayWithEmptyJSON() {
        let string = ""
        XCTAssertThrowsError( try parseString(string, to: TestStructWithRequiredArray.self), "expeced to throw", printError)
    }
    
    func testClassWithRequiredArrayWithInvalidOneInvalidElement() {
        let string = "{\"array\": [\"one\", \"two\", \"invalid\"] }"
        XCTAssertThrowsError( try parseString(string, to: TestStructWithRequiredArray.self), "expeced to throw", printError)
    }
    
    func testClassWithRequiredArrayWithInvalidOneNullElement() {
        let string = "{\"array\": [\"one\", \"two\", null] }"
        XCTAssertThrowsError(try parseString(string, to: TestStructWithRequiredArray.self), "expeced to throw", printError)
    }
    
    
    
    func testExample() {
        
        let jsonString =
        "   {                                                       " +
        "     \"required_string\": \"test-required\",               " +
        "     \"optional_string\": \"test-optional\",               " +
        "     \"required_int\": 123,                                " +
        "     \"optional_int\": 321,                                " +
        "     \"required_bool\": true,                              " +
        "     \"optional_bool\": false,                             " +
        "     \"required_timestamp\": \"2016-09-30T17:18:19.000Z\", " +
        "     \"optional_timestamp\": \"2016-09-30T17:18:19.000Z\", " +
        "     \"required_enum\": \"first\",                         " +
        "     \"optional_enum\": \"second\",                        " +
        "     \"required_class\": {                                 " +
        "       \"required_string\": \"test\",                      " +
        "       \"optional_int\": 123                               " +
        "     },                                                    " +
        "     \"optional_class\": {                                 " +
        "       \"required_string\": \"test\",                      " +
        "       \"optional_int\": 123                               " +
        "     },                                                    " +
        "     \"required_array\": [                                 " +
        "       \"a\",                                              " +
        "       \"b\",                                              " +
        "       \"c\"                                               " +
        "     ],                                                    " +
        "     \"optional_array\": [                                 " +
        "       \"a\",                                              " +
        "       \"b\",                                              " +
        "       \"c\"                                               " +
        "     ],                                                    " +
        "     \"optional_optional_array\": [                        " +
        "       \"a\",                                              " +
        "       \"b\",                                              " +
        "       \"c\"                                               " +
        "     ],                                                    " +
        "     \"required_optional_array\": [                        " +
        "       \"a\",                                              " +
        "       \"b\",                                              " +
        "       \"c\"                                               " +
        "     ]                                                     " +
        "   }                                                       "
        
        let json = JSON.parse(jsonString)
        let entity: ExampleAPI.ExampleEntity
        do {
            entity = try ExampleAPI.ExampleEntity.fromJSON(json)
        } catch let error {
            XCTFail("Could not parse JSON for field \(error)")
            return
        }
        
        
        XCTAssertEqual(entity.requiredString, "test-required")
        XCTAssertEqual(entity.optionalString, "test-optional")
        
        XCTAssertEqual(entity.requiredInt, 123)
        XCTAssertEqual(entity.optionalInt, 321)
        
        XCTAssertEqual(entity.requiredBool, true)
        XCTAssertEqual(entity.optionalBool, false)
        
        XCTAssertEqual(entity.requiredTimestamp, Timestamp(epoch: 1475255899.0))
        XCTAssertEqual(entity.optionalTimestamp, Timestamp(epoch: 1475255899.0))
        
        XCTAssertEqual(entity.requiredEnum, .first)
        XCTAssertEqual(entity.optionalEnum, .second)
        
        XCTAssertEqual(entity.requiredClass.requiredString, "test")
        XCTAssertEqual(entity.requiredClass.optionalInt, 123)
        
        XCTAssertNotNil(entity.optionalClass)
        XCTAssertEqual(entity.optionalClass?.requiredString, "test")
        XCTAssertEqual(entity.optionalClass?.optionalInt, 123)
        

        XCTAssertTrue(entity.requiredArray == ["a", "b", "c"])
        XCTAssertTrue(entity.optionalArray == ["a", "b", "c"])
        XCTAssertTrue(entity.optionalOptionalArray == ["a", "b", "c"])
        XCTAssertTrue(entity.requiredOptionalArray == ["a", "b", "c"])
        
        
        print("requiredString" + entity.requiredString.toJSON().description)
        print("optionalString" + (entity.optionalString?.toJSON().description ?? "nothing"))
        
        print("requiredInt" + entity.requiredInt.toJSON().description)
        print("optionalInt" + (entity.optionalInt?.toJSON().description ?? "nothing"))
        
        print("requiredBool" + entity.requiredBool.toJSON().description)
        print("optionalBool" + (entity.optionalBool?.toJSON().description ?? "nothing"))
                
        print("requiredTimestamp" + entity.requiredTimestamp.toJSON().description)
        print("optionalTimestamp" + (entity.optionalTimestamp?.toJSON().description ?? "nothing"))
                        
        print("requiredEnum" + entity.requiredEnum.toJSON().description)
        print("optionalEnum" + (entity.optionalEnum?.toJSON().description ?? "nothing"))
        
        print("requiredClass.requiredString" + entity.requiredClass.requiredString.toJSON().description)
        print("requiredClass.optionalInt" + (entity.requiredClass.optionalInt?.toJSON().description ?? "nothing"))
        print("requiredClass" + entity.requiredClass.toJSON().description)
                        
        print("optionalClass.requiredString" + (entity.optionalClass?.requiredString.toJSON().description ?? "nothing"))
        print("optionalClass.optionalInt" + (entity.optionalClass?.optionalInt?.toJSON().description ?? "nothing"))
        print("optionalClass" + (entity.optionalClass?.toJSON().description ?? "nothing"))
        
        print("entity.requiredArray" + entity.requiredArray.flatMap{$0}.toJSON().description )
        print("entity.optionalArray" + (entity.optionalArray.flatMap{$0}?.toJSON().description ?? "nothing"))
        print("entity.optionalOptionalArray" + (entity.optionalOptionalArray?.flatMap{$0}.toJSON().description ?? "nothing"))
        print("entity.requiredOptionalArray" + (entity.requiredOptionalArray.flatMap{$0}.toJSON().description ))
        
        print("entity" + entity.toJSON().description)
        
        
        
        do {
            print(try entity.toJSON().rawData(options: .prettyPrinted))
        }catch let error{
            print(error)
        }
        
    }
   
    
}
