//
//  ContentView.swift
//  Multiply
//
//  Created by Gavin Butler on 22-07-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import SwiftUI

struct Question {
    var question: Int
    var answer: Int
}

struct ContentView: View {
    
    @State private var gameActive = false
    @State private var selectedMultiplicationTable = 1
    @State private var questionQuantityIndex = 0
    @State private var endOfGame = false
    
    private let quantityOptions = ["5", "10", "20", "All"]
    
    let maxMultiplicationTable = 12 //Can only do up to 12 x table
    let maximumMultiplier = 10       //Can only multiply up to 12 for each table
    
    @State private var questions: [Question] = []
    @State private var currentQuestionIndex = 0
    @State private var userAnswer: String = ""
    
    @State private var score = 0
    
    var body: some View {
        VStack {
            if gameActive {
                NavigationView {
                    VStack {
                        
                        Text("What is: \(questions[currentQuestionIndex].question) x \(selectedMultiplicationTable) ?")
                            .opacity(endOfGame ? 0 : 1)
                        TextField("Answer?", text: $userAnswer, onCommit: {
                            self.processAnswer()
                        })
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .opacity(endOfGame ? 0 : 1)
                        Text("Score is \(score) / \(currentQuestionIndex)")
                        Text("Total number of questions: \(questions.count)")
                        VStack {
                            Button("Settings") {
                                self.gameActive = false
                            }
                            Button("Play Again") {
                                self.reset()
                            }
                            .opacity(endOfGame ? 1 : 0)
                        }
                        Text("End of game is: \(endOfGame.description)")
                    }
                    .navigationBarTitle("Multiply")
                }
            } else {
                NavigationView {
                    VStack {
                        Spacer()
                        Stepper("Multiplication Table", value: $selectedMultiplicationTable, in: 1...maxMultiplicationTable)
                            .padding()
                        
                        Text("Table: \(selectedMultiplicationTable)")
                        Spacer()
                        
                        Section(header: Text("Select Number of Questions:")) {
                            Picker("", selection: $questionQuantityIndex) {
                                ForEach(0..<quantityOptions.count) {
                                    Text(self.quantityOptions[$0])
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                            .padding()
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                        Text("Number of Questions: \(quantityOptions[questionQuantityIndex])")
                        Spacer()
                        Button("Get Started") {
                            self.reset()
                            self.gameActive = true
                        }
                        Text("GameActive is:\(gameActive ? "True" : "False")")
                    }
                    .navigationBarTitle("Multiply - Settings")
                }
            }
        }
    }
    
    func loadQuestions() {
        let chosenQuantity = quantityOptions[questionQuantityIndex]
        if let questionQuantity = Int(chosenQuantity) { //We have a fixed range
            for _ in 1...questionQuantity {
                let randomNumber = Int.random(in: 1...maximumMultiplier)
                let answer = randomNumber * selectedMultiplicationTable
                questions.append(Question(question: randomNumber, answer: answer))
            }
        } else {    //All option chosen.  Need to simply randomize an array from 1...maximumMultiplier
            let questionSet = Array(1...maximumMultiplier).shuffled()
            for item in questionSet {
                let answer = item * selectedMultiplicationTable
                questions.append(Question(question: item, answer: answer))
            }
        }
    }
    
    func reset() {
        userAnswer = ""
        questions.removeAll()
        score = 0
        currentQuestionIndex = 0
        endOfGame = false
        loadQuestions()
    }
    
    func processAnswer() {
        if let answer = Int(self.userAnswer), answer == questions[currentQuestionIndex].answer {
            score += 1
        }
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            endOfGame = true
        }
        userAnswer = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
