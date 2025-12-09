//
//  TitanicViewModel.swift
//  TitanicCSV
//
//  Created by Uday Kumar Kotla on 07/12/25.
//

import Foundation


/**
 Url : https://raw.githubusercontent.com/datasciencedojo/datasets/refs/heads/master/titanic.csv
 */

@Observable
class TitanicViewModel{
    var passengers : [Passenger] = [
        //dummy data
        Passenger(id: 1, survived: true, pclass: 3, name: "Rani", sex: "Female", age: 25)
    ]
    var isLoading: Bool = false
    
    @ObservationIgnored let urlString = "https://raw.githubusercontent.com/datasciencedojo/datasets/refs/heads/master/titanic.csv"
    
    @MainActor
    func fetchTitanicData() async{
        guard let url = URL(string: urlString) else{
            print("Invalid URL")
            return
        }
        isLoading = true
        defer{
            isLoading = false
        }
        do{
            var firstLine = true // ignore titles column
            var parsedPassengers : [Passenger] = []
            for try await line in url.lines{
                if(firstLine){
                    firstLine = false
                    continue
                }
                /**
                 example line:
                 1,0,3,"Braund, Mr. Owen Harris",male,22,1,0,A/5 21171,7.25,,S
                 2,1,1,"Cumings, Mrs. John Bradley (Florence Briggs Thayer)",female,38,1,0,PC
                print(line)
                 */
                let colm = parserCSVLine(line)
                guard colm.count >= 6 else{
                    continue
                }
                
                let id = Int(colm[0]) ?? -1
                let survived = colm[1] == "1"
                let pclass = Int(colm[2]) ?? -1
                let name = colm[3]
                let sex = colm[4]
                let age = Int(colm[5]) ?? -1
                parsedPassengers.append(Passenger(id: id, survived: survived, pclass: pclass, name: name, sex: sex, age: age))
            }
            passengers = parsedPassengers
        }catch{
            print("Unable to fetch data : \(error)")
        }
        
    }
    
    //CSV parser
    private func parserCSVLine(_ line: String) -> [String] {
        var result : [String] = []
        var current = ""
        var insideQuotes = false
        for char in line{
            if char == "\""{
                insideQuotes.toggle()
            }
            else if(char == "," && !insideQuotes){
                result.append(current)
                current = ""
            }else{
                current.append(char)
            }
        }
        return result
    }
}


