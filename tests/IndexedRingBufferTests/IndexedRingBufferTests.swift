import XCTest
import IndexedRingBuffer

class IndexedRingBufferTests : XCTestCase {
    
    func testPutAndGet() {
        
        var list = IndexedRingBuffer<String>(size: 2)
        
        _ = list.put(value: "hello", at: 0)
        _ = list.put(value: "world", at: 1)
        
        XCTAssert( list.get(at: 0)! == "hello")
        XCTAssert( list.get(at: 1)! == "world")
    }
    
    func testOverflowPutAndGet() {
        
        var list = IndexedRingBuffer<String>(size: 2)
        
        _ = list.put(value: "hello", at: 0)
        _ = list.put(value: "world", at: 1)
        _ = list.put(value: "verden", at: 2)
        
        XCTAssert( list.get(at: 0)! == "verden")
        XCTAssert( list.get(at: 1)! == "world")
        XCTAssert( list.get(at: 2)! == "verden")
        
    }
    
    func testDeletion() {
        
        var list = IndexedRingBuffer<String>(size: 2)
        
        _ = list.put(value: "hello", at: 0)
        
        XCTAssert( list.get(at: 0)! == "hello")
        
        _ = list.del(at: 0)
        
        XCTAssert( list.get(at: 0) == nil)
    }
    
    func testMultithreadedAccess() {
        
        var list = IndexedRingBuffer<String>(size: 2)
        
        for _ in 0 ..< 1_000_000 {
            DispatchQueue.global(qos: .userInitiated).async {
                
                _ = list.put(value: "one", at: 0)
                
                //let val = list.get(at: 0)
                //XCTAssert(val! == "one", "Expected one but found \(val!)")
//                XCTAssert( list.get(at: 0)! == "one")
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                _ = list.put(value: "two", at: 0)
                
                //let val = list.get(at: 0)
                //XCTAssert(val! == "two", "Expected two but found \(val!)")
            }
        }
    }
}
