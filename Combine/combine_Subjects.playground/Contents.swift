import UIKit
import Combine

// debounce - filter out the values on rapid succession
let textPublisher = PassthroughSubject<String, Never>()

let debouncePublisher = textPublisher
    .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)

let cancellable2 = debouncePublisher.sink { val in
    print(val)
}
textPublisher.send("A")
textPublisher.send("A3")
textPublisher.send("A4")
textPublisher.send("A7")

