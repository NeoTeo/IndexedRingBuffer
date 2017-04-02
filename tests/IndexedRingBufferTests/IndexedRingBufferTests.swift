import XCTest
import IndexedRingBuffer

class IndexedRingBufferTests : XCTestCase {
    
    func testPutAndGet() {
        
        var buf = IndexedRingBuffer<String>(size: 2)
        
        _ = buf.put(value: "hello", at: 0)
        _ = buf.put(value: "world", at: 1)
        
        XCTAssert( buf.get(at: 0)! == "hello")
        XCTAssert( buf.get(at: 1)! == "world")
    }
    
    func testOverflowPutAndGet() {
        
        var buf = IndexedRingBuffer<String>(size: 2)
        
        _ = buf.put(value: "hello", at: 0)
        _ = buf.put(value: "world", at: 1)
        _ = buf.put(value: "verden", at: 2)
        
        XCTAssert( buf.get(at: 0)! == "verden")
        XCTAssert( buf.get(at: 1)! == "world")
        XCTAssert( buf.get(at: 2)! == "verden")
        
    }
    
    func testDeletion() {
        
        var buf = IndexedRingBuffer<String>(size: 2)
        
        _ = buf.put(value: "hello", at: 0)
        
        XCTAssert( buf.get(at: 0)! == "hello")
        
        _ = buf.del(at: 0)
        
        XCTAssert( buf.get(at: 0) == nil)
    }
    
    func testMultithreadedAccess() {
        
        var buf = IndexedRingBuffer<String>(size: 2)
        
        for _ in 0 ..< 1_000_000 {
            DispatchQueue.global(qos: .userInitiated).async {
                
                _ = buf.put(value: "one", at: 0)
                
                //let val = buf.get(at: 0)
                //XCTAssert(val! == "one", "Expected one but found \(val!)")
//                XCTAssert( buf.get(at: 0)! == "one")
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                _ = buf.put(value: "two", at: 0)
                
                //let val = buf.get(at: 0)
                //XCTAssert(val! == "two", "Expected two but found \(val!)")
            }
        }
    }
}
