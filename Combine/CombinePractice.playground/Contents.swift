import UIKit
import Foundation
import Combine
import Dispatch
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
//Just Publisher -> publish one value
//subscription  return something in form of AnyCancellable hold and cancel the subscription
let j_publisher = Just("Hello") //return publisher
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


// Error Handling and Completion

enum NumError : Error {
    case zeroSupplied
}
let numberPub = [2,4,6,8,0,10].publisher

let halfPub = numberPub.tryMap { val in
    if val == 0{ throw NumError.zeroSupplied}
    return String(val/2)
}
//.catch {err in
//    if let e = err as? NumError, e == .zeroSupplied{
//        return Just("Zero not allowed")
//    }
//    return Just("Error occured")
//}

// instead of catch we can use
    .replaceError(with: "-1")



halfPub.sink { completion in
    switch completion{
    case .finished: print("finished")
    case .failure(let err): print("error : \(err)")
    }
} receiveValue: { val in
    print(val,terminator: "->")
}


//flat Map

let namePub = [
    ["uk", "aus"],
    ["india"],
    ["america", "ny"]
].publisher

let flatttendName = namePub.flatMap{$0.publisher}

flatttendName.sink { val in
    print(val)
}

// merge - merge 2 same type publishers

let p1 = [1,2,3].publisher
let p2 = [4,5,6].publisher

//merge
let mergePublisher = Publishers.Merge(p2,p1)
mergePublisher.sink { val in print(val,terminator: "+")}
print("\n")

//filter -  filter values
let filterpublisher = mergePublisher.filter {$0%2 == 0}
filterpublisher.sink { val in print(val,terminator: ",")}
print("\n")

//copmpact map
let stringPublisher = ["1","2B","A","5","4"].publisher
let intPublisher = stringPublisher.compactMap(Int.init)
intPublisher.sink { val in print(val,terminator: ",")}
print("\n")

// debounce - filter out the values on rapid succession

Task{
    let textPublisher = PassthroughSubject<String, Never>()
    let debouncePublisher = textPublisher
        .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
    
    let cancellable2 = debouncePublisher.sink { val in
        print(val)
    }
    textPublisher.send("A")
    textPublisher.send("A3")
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    textPublisher.send("A4")
    textPublisher.send("A7")
    try? await Task.sleep(nanoseconds: 1_000_000_000)
}

//combining Operators

let p3 = CurrentValueSubject<Int,Never>(3)
let p4 = CurrentValueSubject<Int,Never>(4)

let combinePubliser = p3.combineLatest(p4).sink{ v1,v2 in
    print("CombineLatest values : ")
    print(v1,v2)
}

p4.send(6)
p3.send(5)

//zip

let p5 = [1,2,3,4,5].publisher
let p6 = ["a","s","d"].publisher
let p7 = [11,12,13,14,15].publisher
let zipPub = p5.zip(p6).sink{ v1,v2 in
    print("zip value : ") //it run min number of publisher value
    // 1,2,3 ,a,s,d // wont trigger 4,5
    print(v1,v2)
}

// if we want to access zip n publsihers
let nzipPub = p5.zip(p6,p7).sink{ v1,v2, v3 in
    print("nzip value : ") //it run min number of publisher value
    // 1,2,3 ,a,s,d // wont trigger 4,5
    print(v1,v2,v3)
}

let n1zipPub = Publishers.Zip3(p5,p6,p7).sink{ v1,v2, v3 in
    print("n1zip value : ") //it run min number of publisher value
    // 1,2,3 ,a,s,d // wont trigger 4,5
    print(v1,v2,v3)
}


//switch to latest - switch and read the different inner publishers

let outerPublisher = PassthroughSubject<AnyPublisher<Int,Never>,Never>()
let innerPublisher1 = CurrentValueSubject<Int,Never>(1)
let innerPublisher2 = CurrentValueSubject<Int,Never>(2)

let c1 = outerPublisher.switchToLatest()
    .sink{print("STL \($0)")}
//eg
outerPublisher.send(AnyPublisher(innerPublisher1))
innerPublisher1.send(10)
outerPublisher.send(AnyPublisher(innerPublisher2))
innerPublisher2.send(20)
innerPublisher2.send(200)

enum SampleError: Error {
    case operartionDenied
}

//retry publisher

print("\n \n")
let p8 = [1,2,3,4,3,5,6,3,7].publisher
let c8 = p8
    .tryMap{
        val in
        if val == 3 {
            throw SampleError.operartionDenied
        }
        return val
    }
    .retry(2)
    .sink(
        receiveCompletion: { completion in
            print("Completion:", completion)
        },
        receiveValue: { val in
            print(val)
        }
    )

print("\n \n")
/* it prints
 1
 2
 1
 2
 1
 2
 Completion: failure(SampleError.operationDenied)
 
 Stops at 1,2 because 3 throws an error
 
 Errors immediately terminate the stream
 
 retry restarts but does not skip the error
 
 Total executions = 1 (original) + 2 (retries) = 3
 */



let p9 = PassthroughSubject<Int , Error>()

let c9 = p9
    .tryMap{
        val in
        if val == 3 {
            throw SampleError.operartionDenied
        }
        return val
    }
    .retry(2)
    .sink(
        receiveCompletion: { completion in
            print("Completion:", completion)
        },
        receiveValue: { val in
            print(val)
        }
    )

p9.send(111)
p9.send(3)
p9.send(114)
p9.send(115)
p9.send(3)
p9.send(118)
p9.send(3)
p9.send(133)



//custom subjects

class EvenSubject<Failure : Error> : Subject{
    
    typealias Output = Int
    
    let wrapper : PassthroughSubject<Int,Failure>
    
    init(initialValue:Int){
        self.wrapper = PassthroughSubject()
        let evenInitalValue = initialValue % 2 == 0 ? initialValue : 0
        send(evenInitalValue)
    }
    
    func send(subscription: Subscription) {
        wrapper.send(subscription: subscription)
    }
    
    func send(_ value: Int) {
        if value % 2 == 0 {wrapper.send(value)}
    }
    
    func send(completion: Subscribers.Completion<Failure>) {
        wrapper.send(completion: completion)
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Int == S.Input {
        wrapper.receive(subscriber: subscriber)
    }
}

let es = EvenSubject<Never>(initialValue: 10)
let ces = es.sink { print("even sub : \($0)") }

es.send(20)
es.send(21)
es.send(210)


@MainActor
class WeatherClient{
    let updates = PassthroughSubject<Int,Never>()
    
    func fetchWeather(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){ [weak self] in
            guard let self else {return}
            self.updates.send(Int.random(in: 100...120))
        }
        
    }
}

let wc = WeatherClient()
let canWc = wc.updates.sink(receiveValue: { print("weather : \($0)") })
wc.fetchWeather()
wc.fetchWeather()


