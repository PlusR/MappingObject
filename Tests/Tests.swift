import MappingObject
import XCTest

func ==(l: [String: AnyObject], r: [String: AnyObject]) -> Bool {
    return true
}

class Person: NSObject, MappingObject {
    var identifier: String
    var age: Int
    var name: String
    
    init(identifier: String, age: Int, name: String) {
        self.identifier = identifier
        self.age = age
        self.name = name
        super.init()
    }
    
    func keyMap() -> [String: String] {
        return [
            "identifier": "identifier",
            "age": "age",
            "name": "name"
        ]
    }
    func valueTransformerNames() -> [String: String] {
        return [:]
    }
}

class MappinObjectTests: XCTestCase {
    func testHoge() {
        let object = Person(identifier: "iden", age: 21, name: "Jun")
        let expect: [String : AnyObject] = [
            "identifier": "iden",
            "age": 21,
            "name": "Jun"
        ]
        let result = object.toDictionary()
        XCTAssertEqual(expect.count, result.count)
        for (key, obj) in expect {
            if let l = obj as? NSObject, r = result[key] as? NSObject {
                XCTAssert(l.isEqual(r), "\(key): \(l) iseq \(r)")
            } else {
                XCTFail("key: \(key), obj: \(obj), result[key]: \(result[key])")
            }
        }
    }
}