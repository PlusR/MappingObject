
public protocol MappingObject {
    func valueForKey(key: String) -> AnyObject?
    func setValue(value: AnyObject?, forKey key: String)
    
    func keyMap() -> [String: String]
    func valueTransformerNames() -> [String: String]
}

public extension MappingObject {
    public mutating func update(dictionary: [String : AnyObject]) {
        let valueTransformerNames = self.valueTransformerNames()
        for (oKey, dKey) in self.keyMap() {
            let dictionaryValue = dictionary[dKey];
            let transformerName = valueTransformerNames[oKey];
            if let value = transformedValue(dictionaryValue, transformerName: transformerName) {
                if NSNull().isEqual(value) {
                    self.setValue(nil, forKey: oKey)
                } else {
                    self.setValue(value, forKey: oKey)
                }
            }
        }
    }
    func transformedValue(value: AnyObject?, transformerName: String?) -> AnyObject? {
        if let name = transformerName {
            let transformer = NSValueTransformer(forName: name)!
            return transformer.transformedValue(value)
        } else {
            return value
        }
    }
    public func toDictionary() -> [String : AnyObject] {
        var result = [String: AnyObject]()
        let valueTransformerNames = self.valueTransformerNames()
        for (oKey, dKey) in self.keyMap() {
            let objectValue = valueForKey(oKey)
            let transformerName = valueTransformerNames[oKey];
            if let value = reverseTransformedValue(objectValue, transformerName: transformerName) {
                result[dKey] = value
            }
        }
        return result
    }
    func reverseTransformedValue(value: AnyObject?, transformerName: String?) -> AnyObject? {
        if let name = transformerName {
            let transformer = NSValueTransformer(forName: name)!
            if transformer.dynamicType.allowsReverseTransformation() {
                return transformer.reverseTransformedValue(value)
            }
        }
        return value
    }
}

