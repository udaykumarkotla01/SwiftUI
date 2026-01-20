import UIKit
import Foundation
import Combine

//Just Publisher -> publish one value

let j_publisher = Just("Hello") //return publisher

//subscription  return something in form of AnyCancellable hold and cancel the subscription
let cancellable = j_publisher.sink(receiveValue: { print($0) })
j_publisher.sink{
    value in
    print(value)
}

//cancellable will call automatically when we move out of scope
cancellable.cancel()


// sequence publisher
let  num_publisher = [1,2,3,4,5,6].publisher
//map operator
let double_publisher = num_publisher.map { $0 * 2 }
double_publisher.sink(receiveValue: { print($0,terminator: "->") })
print("\n")


//Default avaible publishers like timer publisher, notifcation center

let timerPublisher = Timer.publish(every: 1, on: .main, in: .default)
let cancelled = timerPublisher.autoconnect()
    .prefix(2) // publish onlly 2 values
    .sink{
    val in
    print("timer: \(val)")
}


//Handling subscription life cycle

let numsPublisher = (1...10).publisher
let cancellable1 = numsPublisher.sink { val in
        print(val)
}


//assign to'
class Clock {
    var time : Date = .now {
        didSet{print("time Updated \(time)")}
    }
}

let clock = Clock()
Timer.publish(every: 1, on: .main, in: .common).autoconnect().assign(to: \.time , on: clock)
