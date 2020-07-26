//
//  ContentView.swift
//  Multiply
//
//  Created by Gavin Butler on 22-07-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    
    @State private var gameActive = false
    @State private var selectedMultiplicationTable = 1
    @State private var questionQuantityIndex = 0
    @State private var endOfGame = false
    
    private let quantityOptions = ["5", "10", "20", "All"]
    
    let maxMultiplicationTable = 12 //Can only do up to 12 x table
    let maximumMultiplier = 10       //Can only multiply up to 12 for each table
    
    private var tableIncrementable: Bool {
        selectedMultiplicationTable < maxMultiplicationTable
    }
    private var tableDecrementable: Bool {
        selectedMultiplicationTable > 1
    }
    private var questionQuantityIncrementable: Bool {
        questionQuantityIndex < quantityOptions.count - 1
    }
    private var questionQuantityDecrementable: Bool {
        questionQuantityIndex > 0
    }
    
    @State private var questions: [Question] = []
    @State private var currentQuestionIndex = 0
    @State private var userAnswer: String = ""
    @State private var savedAnswer: String = ""
    @State private var answerPointer: Int = 0
    
    @State private var score = 0
    
    var body: some View {
        VStack {
            if gameActive {
                NavigationView {
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [.white, .blue]), startPoint: .top, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
                        VStack {
                            HStack {
                                Button(action: {
                                    self.gameActive = false
                                }) {
                                    NavigationButtonImage(title: "Settings", colour: .black)
                                }
                                Spacer()
                                Button(action: {
                                    self.reset()
                                }) {
                                    NavigationButtonImage(title: "Again?", colour: .black)
                                }
                                .opacity(endOfGame ? 1 : 0)
                            }
                            HStack(alignment: .bottom) {
                                LargeNumberText(title: "\(questions[currentQuestionIndex].question)", colour: .green)
                                Text("X")
                                    .font(.system(size: 40, weight: .bold))
                                    .padding(15)
                                    .foregroundColor(.green)
                                LargeNumberText(title: "\(selectedMultiplicationTable)", colour: .green)
                            }
                            .opacity(endOfGame ? 0 : 1)
                            Text("User entered: \(savedAnswer)")
                            Group {
                                VStack {
                                    ForEach(0 ..< 3) { row in
                                        HStack {
                                            ForEach(0 ..< 3) {column in
                                                Button(action: {
                                                    let ans = (row * 3 + column + 1).description
                                                    self.userAnswer = ans
                                                    self.processAnswer()
                                                }) {
                                                NumberButtonImage(title: "\(row * 3 + column + 1)", colour: .black)
                                                }
                                            }
                                        }
                                    }
                                }.disabled(endOfGame)
                                Button(action: {
                                    self.userAnswer = "0"
                                    self.processAnswer()
                                }) {
                                NumberButtonImage(title: "0", colour: .black)
                                }
                            }
                            Text("Score is \(score) / \(currentQuestionIndex)")
                            Text("Total number of questions: \(questions.count)")
                            Text("End of game is: \(endOfGame.description)")
                        }
                        .navigationBarTitle(Text("Multiply").font(.footnote).foregroundColor(.green))
                    }
                }
            } else {
                NavigationView {
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [.white, .blue]), startPoint: .top, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
                        VStack {
                            Section {
                                Spacer()
                                Spacer()
                                Spacer()
                                LargeNumberText(title: "\(selectedMultiplicationTable)", colour: .green)
                                Text("Times Table")
                                .foregroundColor(.green)
                                HStack {
                                    Button(action: {
                                        self.selectedMultiplicationTable -= 1
                                    }) {
                                        ButtonImage(imageSymbolName: "arrowtriangle.down.fill")
                                        .offset(x: 0, y: 2)
                                    }
                                    .pushButtonStyle(colour: .green)
                                    .disabled(tableDecrementable ? false : true)
                                    .opacity(tableDecrementable ? 1 : 0.5)
                                    Button(action: {
                                        self.selectedMultiplicationTable += 1
                                        }) {
                                            ButtonImage(imageSymbolName: "arrowtriangle.up.fill")
                                        }
                                    .pushButtonStyle(colour: .green)
                                    .disabled(tableIncrementable ? false : true)
                                    .opacity(tableIncrementable ? 1 : 0.5)
                                }
                            }
                            Spacer()
                            LargeNumberText(title: "\(quantityOptions[questionQuantityIndex])", colour: .red)
                            Text("Questions")
                            .foregroundColor(.red)
                            HStack {
                                Button(action: {
                                    self.questionQuantityIndex -= 1
                                }) {
                                    ButtonImage(imageSymbolName: "arrowtriangle.down.fill")
                                    .offset(x: 0, y: 2)
                                }
                                .pushButtonStyle(colour: .red)
                                .disabled(questionQuantityDecrementable ? false : true)
                                .opacity(questionQuantityDecrementable ? 1 : 0.5)
                                Button(action: {
                                    self.questionQuantityIndex += 1
                                    }) {
                                        ButtonImage(imageSymbolName: "arrowtriangle.up.fill")
                                    }
                                .pushButtonStyle(colour: .red)
                                .disabled(questionQuantityIncrementable ? false : true)
                                .opacity(questionQuantityIncrementable ? 1 : 0.5)
                            }
                            Button(action: {
                                self.reset()
                                self.gameActive = true
                            }) {
                                NavigationButtonImage(title: "Start", colour: .black)
                            }
                            Text("GameActive is:\(gameActive ? "True" : "False")")
                        }
                        .navigationBarTitle("Multiply - Settings")
                    }
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
        answerPointer = 0
        loadQuestions()
    }
    
    func processAnswer() {
        savedAnswer = userAnswer
        let currentQuestion = questions[currentQuestionIndex]
        guard answerPointer < currentQuestion.answerChars.count else { return }
        let increment = currentQuestionIndex == questions.count - 1 ? 0 : 1
        
        if String(currentQuestion.answerChars[answerPointer]) == userAnswer {
            if answerPointer == currentQuestion.answerChars.count - 1 {  //answer is correct
                score += 1
                currentQuestionIndex += increment
            } else {
                return      //still processing digits on this question
            }
        } else {
            currentQuestionIndex += increment   //User got it wrong
        }
        
        if increment == 0 {
            endOfGame = true
        }
        userAnswer = ""
        answerPointer = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Question {
    var question: Int
    var answer: Int
    var answerChars: [String.Element] {
        Array(answer.description)
    }
}

struct ButtonImage: View {
    var imageSymbolName: String
    
    var body: some View {
        Image(systemName: imageSymbolName)
        .renderingMode(nil)
        .foregroundColor(.white)
        .font(.largeTitle)
    }
}

struct PushButton: ViewModifier {
    var colour: Color
    func body(content: Content) -> some View {
        content
            .frame(width: 70, height: 70)
            .background(colour)
            .foregroundColor(.white)
            .clipShape(Circle())
            .padding(40)
    }
}

extension View {
    func pushButtonStyle(colour: Color) -> some View {
        self.modifier(PushButton(colour: colour))
    }
}

struct LargeNumberText: View {
    let title: String
    let colour: Color
    var body: some View {
        Text(title)
        .font(.system(size: 80, weight: .bold))
        .foregroundColor(colour)
        .padding(5)
    }
}

struct NavigationButtonImage: View {
    let title: String
    let colour: Color
    var body: some View {
        Text(title)
        .frame(width: 100, height: 100)
        .font(.system(size: 25))
        .background(colour)
        .foregroundColor(.white)
        .clipShape(Circle())
        .padding(10)
    }
}

struct NumberButtonImage: View {
    let title: String
    let colour: Color
    var body: some View {
        Text(title)
        .frame(width: 100, height: 100)
            .font(.system(size: 30))
        .background(colour)
        .foregroundColor(.white)
        .clipShape(Circle())
        .padding(5)
    }
}
