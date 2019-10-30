//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

class GCDUtils{
  static func time(secs:Double) -> dispatch_time_t{
    return dispatch_time(DISPATCH_TIME_NOW, Int64(secs * Double(NSEC_PER_SEC)))
  }
}

protocol ExecutableQueue{
  var queue : dispatch_queue_t{get}
}

extension ExecutableQueue{
  func execute_sync(closure: () -> Void){
    dispatch_sync(queue, closure)
  }
  func execute_async(closure: () -> Void){
    dispatch_async(queue, closure)
  }
  func execute_after(secs:Double, closure: () -> Void){
    let t = dispatch_time(DISPATCH_TIME_NOW, Int64(secs * Double(NSEC_PER_SEC)))
    dispatch_after(t, queue, closure)
  }
}

enum SyncQueue: String, ExecutableQueue {
  static let queues:[SyncQueue] = [.Q1, .Q2, .Q3, .Q4, .Q5]
  
  case Q1 = "com.xxx.Q1"
  case Q2 = "com.xxx.Q2"
  case Q3 = "com.xxx.Q3"
  case Q4 = "com.xxx.Q4"
  case Q5 = "com.xxx.Q5"
  
  private static func _qCreate(q:SyncQueue) -> dispatch_queue_t {
    return dispatch_queue_create(q.rawValue, DISPATCH_QUEUE_SERIAL)
  }
  private static let Q1_q = SyncQueue._qCreate(.Q1)
  private static let Q2_q = SyncQueue._qCreate(.Q2)
  private static let Q3_q = SyncQueue._qCreate(.Q3)
  private static let Q4_q = SyncQueue._qCreate(.Q4)
  private static let Q5_q = SyncQueue._qCreate(.Q5)
  
  var queue : dispatch_queue_t {
    switch self{
    case .Q1:
      return SyncQueue.Q1_q
    case .Q2:
      return SyncQueue.Q2_q
    case .Q3:
      return SyncQueue.Q3_q
    case .Q4:
      return SyncQueue.Q4_q
    case .Q5:
      return SyncQueue.Q5_q
      
    }
  }
}

public final class AtomicOptionalProperty<T> {
  private var _value:T?
  private let qIdx = Int(arc4random_uniform(5))
  public var value: T?{
    get{
      var v:T?
      SyncQueue.queues[qIdx].execute_sync{
        v = self._value
      }
      return v
    }
    set{
      SyncQueue.queues[qIdx].execute_sync{
        self._value = newValue
      }
    }
  }
  
  public init(){
  }
  
  public init(_ value: T){
    self._value = value
  }
}

public final class AtomicProperty<T> {
  private var _value:T
  private let qIdx = Int(arc4random_uniform(5))
  public var value: T{
    get{
      var v:T?
      SyncQueue.queues[qIdx].execute_sync{
        v = self._value
      }
      return v!
    }
    set{
      SyncQueue.queues[qIdx].execute_sync{
        self._value = newValue
      }
    }
  }
  
  public init(_ value: T){
    self._value = value
  }
}


let atomic = AtomicProperty("Foo")
atomic.value
atomic.value = "Bar"
atomic.value

let atomic_opt = AtomicOptionalProperty<String>()
atomic_opt.value
atomic_opt.value = "Foo Bar"
atomic_opt.value
