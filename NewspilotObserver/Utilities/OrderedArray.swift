
public struct OrderedArray<T:Comparable> {
    fileprivate var array = [T]()
    
    public init(array: [T]) {
        self.array = array.sorted()
    }
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public subscript(index: Int) -> T {
        return array[index]
    }
    
    public mutating func removeAtIndex(index: Int) -> T {
        return array.remove(at: index)
    }
    
    public mutating func removeAll() {
        array.removeAll()
    }
    
    public mutating func insert(_ newElement: T) -> Int {
        let i = findInsertionPoint(newElement)
        array.insert(newElement, at: i)
        return i
    }
    
    public func firstIndex(of element:T) -> Int? {
        return array.firstIndex(of: element)
    }
    
    public func firstIndex(where f:(T) throws -> Bool) rethrows -> Int? {
        return try array.firstIndex(where: f)
    }

    /*
     // Slow version that looks at every element in the array.
     private func findInsertionPoint(newElement: T) -> Int {
     for i in 0..<array.count {
     if newElement <= array[i] {
     return i
     }
     }
     return array.count
     }
     */
    
    // Fast version that uses a binary search.
    private func findInsertionPoint(_ newElement: T) -> Int {
        var startIndex = 0
        var endIndex = array.count
        
        while startIndex < endIndex {
            let midIndex = startIndex + (endIndex - startIndex) / 2
            if array[midIndex] == newElement {
                return midIndex
            } else if array[midIndex] < newElement {
                startIndex = midIndex + 1
            } else {
                endIndex = midIndex
            }
        }
        return startIndex
    }
}

extension OrderedArray: CustomStringConvertible {
    public var description: String {
        return array.description
    }
}
