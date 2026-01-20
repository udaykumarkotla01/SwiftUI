//
//  ContentView.swift
//  TimerApp_Combine
//
//  Created by Uday Kumar Kotla on 13/01/26.
//

import SwiftUI
import Combine

class Clock{
    
}

@Observable
class TimerVM{
    var date : Date = .now
    var timestring : String { date.formatted(date: .omitted, time: .standard)
    }
    private var cancellable: AnyCancellable?
    init(){
        let publisher = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
            .prefix(5)
        cancellable = publisher.assign(to: \.date, on: self)
    }
}

struct ContentView: View {
    var vm = TimerVM()
    var body: some View {
        VStack {
            Text("Time : \(vm.timestring)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
