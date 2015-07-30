import MappingObject
import XCTest

func ==(l: [String: AnyObject], r: [String: AnyObject]) -> Bool {
    return true
}

class Unit: NSObject, MappingObject {
    var centimeter: Double
    var date: NSDate
    var identifier: String
    
    init(centimeter: Double, date: NSDate, identifier: String) {
        self.centimeter = centimeter
        self.date = date
        self.identifier = identifier
        super.init()
    }
    
    func keyMap() -> [String: String] {
        return [
            "identifier": "identifier",
            "date": "date",
            "centimeter": "centimeter"
        ]
    }
    func valueTransformerNames() -> [String: String] {
        return [:]
    }
}

class Person: NSObject, MappingObject {
    var identifier: String
    var age: Int
    var name: String
    var units: [Unit]
    
    init(identifier: String, age: Int, name: String) {
        self.identifier = identifier
        self.age = age
        self.name = name
        self.units = []
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
        checkDictionary(expect, result)
    }
    func checkDictionary<T, U>(d1: [T: U],_ d2: [T: U]) {
        XCTAssertEqual(d1.count, d2.count)
        for (key, obj) in d1 {
            if let l = obj as? NSObject, r = d2[key] as? NSObject {
                XCTAssert(l.isEqual(r), "\(key): \(l) iseq \(r)")
            } else {
                XCTFail("key: \(key), obj: \(obj), result[key]: \(d2[key])")
            }
        }
    }
    func person() -> Person {
        let path = NSBundle(forClass: self.dynamicType).pathForResource("person", ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: path) as! [String: AnyObject]
        var person = Person(identifier: "", age: 0, name: "")
        person.update(dictionary)
        return person
    }
    
    func unit() -> Unit {
        let path = NSBundle.mainBundle().pathForResource("unit", ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: path) as! [String: AnyObject]
        var unit = Unit(centimeter: 0, date: NSDate(), identifier: "")
        unit.update(dictionary)
        return unit
    }
    
    func testInsertWithDictionary() {
        let person = self.person()
        checkDictionary(person.toDictionary(), [
            "identifier": "xxx-xxx-xxx",
            "age": 20,
            "name": "John"
        ])
    }
}
/*

- (void)testInsertWithDictionary {
PersonJSONModel *jsonModel = [self personJSONModel];
Person *person = [Person insertNewWithDictionary:jsonModel.dictionaryRepresentation managedObjectContext:[NSManagedObjectContext MR_defaultContext]];
XCTAssertEqualObjects([person dictionaryRepresentation], [jsonModel dictionaryRepresentation], @"dict -> NSManagedObject -> dict");
}

- (void)testNilDictionaryRepresentation {
PersonJSONModel *jsonModel = [self personJSONModel];
jsonModel.name = nil;
Person *person = [Person insertNewWithDictionary:jsonModel.dictionaryRepresentation managedObjectContext:[NSManagedObjectContext MR_defaultContext]];
XCTAssertEqualObjects([person dictionaryRepresentation], [jsonModel dictionaryRepresentation], @"name doesn't exist");
}

- (void)testTransform {
UnitJSONModel *jsonModel = [self unitJSONModel];
Unit *unit = [Unit insertNewWithDictionary:jsonModel.dictionaryRepresentation managedObjectContext:[NSManagedObjectContext MR_defaultContext]];
XCTAssertEqualObjects([unit dictionaryRepresentation], [jsonModel dictionaryRepresentation], @"dict -> NSManagedObject -> dict");
}

- (void)testUpdateWithDictionary {
PersonJSONModel *jsonModel = [self personJSONModel];
Person *person = [Person insertNewWithDictionary:jsonModel.dictionaryRepresentation managedObjectContext:[NSManagedObjectContext MR_defaultContext]];
Person *person_tw = [Person insertNewWithDictionary:jsonModel.dictionaryRepresentation managedObjectContext:[NSManagedObjectContext MR_defaultContext]];
XCTAssertTrue([self isEqualPropertyOfPerson:person toPerson:person_tw], @"All property is same");
jsonModel.name = @"new name";
[person_tw updateWithDictionary:jsonModel.dictionaryRepresentation];
XCTAssertTrue(![self isEqualPropertyOfPerson:person toPerson:person_tw], @"name is difference");
}

- (void)testUpdateWithNilDictionary {
PersonJSONModel *jsonModel = [self personJSONModel];
Person *person = [Person insertNewWithDictionary:jsonModel.dictionaryRepresentation managedObjectContext:[NSManagedObjectContext MR_defaultContext]];
Person *person_tw = [Person insertNewWithDictionary:jsonModel.dictionaryRepresentation managedObjectContext:[NSManagedObjectContext MR_defaultContext]];
XCTAssertTrue([self isEqualPropertyOfPerson:person toPerson:person_tw], @"All property is same");
jsonModel.name = nil;
jsonModel.internalBaseClassIdentifier = nil;
[person_tw updateWithDictionary:jsonModel.dictionaryRepresentation];
XCTAssertTrue([self isEqualPropertyOfPerson:person toPerson:person_tw], @"not update with missing key");
}

- (void)testTransformRelationShipToMany {
PersonJSONModel *jsonModel = [self personJSONModel];
Person *person = [Person insertNewWithDictionary:jsonModel.dictionaryRepresentation managedObjectContext:[NSManagedObjectContext MR_defaultContext]];
XCTAssertTrue([[person dictionaryRepresentation] isKindOfClass:[NSDictionary class]], @"should be NSDictionary");
}

- (void)testUpdateNullPerson {
PersonJSONModel *jsonModel = [self personJSONModel];
Person *person = [Person insertNewWithDictionary:jsonModel.dictionaryRepresentation managedObjectContext:[NSManagedObjectContext MR_defaultContext]];
NSDictionary *dictionary = @{
PersonAttributes.age: [NSNull null],
@"id": [NSNull null],
PersonAttributes.name: [NSNull null],
@"units": [NSNull null],
};
[person updateWithDictionary:dictionary];
XCTAssertEqualObjects([person dictionaryRepresentation], @{ @"units":@[] }, @"update null property");
}

- (BOOL)isEqualPropertyOfPerson:(Person *)person toPerson:(Person *)toPerson {
return ([person.name isEqualToString:toPerson.name]
&& [person.identifier isEqualToString:toPerson.identifier]
&& [person.age isEqualToNumber:toPerson.age]);
}
@end
*/
