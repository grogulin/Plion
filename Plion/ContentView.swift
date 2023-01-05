//
//  ContentView.swift
//  Plion
//
//  Created by Ярослав Грогуль on 04.01.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isActive = false
    @State private var screenTitle = ""
    @State private var buttonTitle = ""
    @State private var showingScore = false
    
    @State private var currentRound = 0
    @State private var totalRounds = 5
    @State private var roundAmounts = [5, 10, 20, 50]
    @State private var upTo = 10
    @State private var tableCeiling = 10
    @State private var score = 0
    
    @State private var gameStatus : gameStatuses = .startScreen
    
    @State private var exerciseNumbers = [[Int]]()
    @State private var typedResult = ""
    @FocusState private var isInputActive: Bool
    @FocusState private var focusedField: FocusedField?
    
    @State private var resultRotation = 0.0
    @State private var resultShake = CGSize.init(width: 0, height: 5)
    @State private var hardMode = false
    
    
    enum gameStatuses {
        case startScreen
        case exerciseScreen
        case resultsScreen
    }
    
    enum FocusedField {
            case typedInput
    }
    
    func showScore() {
        
        if isActive && currentRound == totalRounds {
            currentRound = 0
            showingScore = true
        }
    }
    
    func startGame() {
        withAnimation {
            switch gameStatus {
            case .startScreen:
                gameStatus = .exerciseScreen
                currentRound += 1
//                getExercises(examMode: false)
            case .exerciseScreen:
                if currentRound == totalRounds { gameStatus = .resultsScreen }
            case .resultsScreen:
                gameStatus = .startScreen
                score = 0
                currentRound = 0
                hardMode = false
            }
        }
    }
    
    func takeExercises() {
        withAnimation {
            checkAnswer()
            switch currentRound {
            case 0..<totalRounds:
                currentRound += 1
            case totalRounds:
                gameStatus = .resultsScreen
            default: return
            }
        }
    }
    
    func getTitle() {
        withAnimation {
            switch gameStatus {
            case .startScreen:
                screenTitle = "Ready for a new game?"
            case .exerciseScreen:
                screenTitle = "Let's Multiply!"
            case .resultsScreen:
                screenTitle = "Your result:"
            }
            
            switch gameStatus {
            case .startScreen:
                buttonTitle = "Start the practice";
            case .exerciseScreen:
                buttonTitle = "Done";
            case .resultsScreen:
                buttonTitle = "Ok";
            }
        }
        
    }
    
    func getButton() {
        withAnimation {
            switch gameStatus {
            case .startScreen:
                buttonTitle = "Start the game";
            case .exerciseScreen:
                buttonTitle = "Done";
            case .resultsScreen:
                buttonTitle = "Ok";
            }
        }
    }
    
    func getExercises(examMode: Bool) {
        if examMode {
            withAnimation{
                hardMode = true
            }
        }
        exerciseNumbers = [[Int]]()
        
        for _ in 0...totalRounds {
            if examMode {
                exerciseNumbers.append([Int.random(in: 1...upTo), Int.random(in: 1...tableCeiling)].shuffled())
            } else {
                exerciseNumbers.append([upTo, Int.random(in: 1...tableCeiling)].shuffled())
            }
            
        }
    }
    
    func checkAnswer() {
        guard let answer = Int(typedResult) else {
            return
        }
        if answer == (exerciseNumbers[currentRound-1][0] * exerciseNumbers[currentRound-1][1]) {
            score += 1
        }
    }
    
    var body: some View {
        ZStack {
            if hardMode {
                Color(red: 1, green: 0.4, blue: 0.4)
                    .ignoresSafeArea()
            } else {
                Color(red: 0.3, green: 0.8, blue: 0.5)
                    .ignoresSafeArea()
            }
                
            VStack {
                HStack {
                    Text(screenTitle)
//                        .background(.red)
                        .fontDesign(.rounded)
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(EdgeInsets(top: 60, leading: 0, bottom: 30, trailing: 10))
                
                
                if gameStatus == .startScreen {
//                    Stepper("Numbers to learn (up to \(upTo)", value: $upTo)
                    Stepper("Number to learn (\(upTo))", value: $upTo, in: 1...20)
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                    Stepper("Numbers of rounds (\(totalRounds))", value: $totalRounds, in: 5...50, step: 5)
                        .foregroundColor(.white)
                        .font(.system(size: 20))
//                    HStack {
//                        Text("Numbers of rounds (\(totalRounds))")
//                            .foregroundColor(.white)
//                            .font(.system(size: 20))
//                        Spacer()
//                        Stepper("", value: $totalRounds, in: 5...50, step: 5)
//                            .foregroundColor(.white)
//                            .font(.system(size: 20))
//
//                    }
                }
                
                if gameStatus == .exerciseScreen {
                    HStack {
                        Text("Round \(currentRound) of \(totalRounds).")
    //                        .background(.red)
                            .fontDesign(.rounded)
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 10, trailing: 10))
                }
                
                if showingScore {
                    HStack {
                        Text("Score: Showing score: \(String(showingScore))")
    //                        .background(.red)
                            .fontDesign(.rounded)
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10))
                    
                }
                
                if gameStatus == .exerciseScreen {
                    HStack {
                        Spacer()
                        Text("\(exerciseNumbers[currentRound-1][0]) x \(exerciseNumbers[currentRound-1][1]) = ")
                        //                        .background(.red)
                            .fontDesign(.rounded)
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(minWidth: 230)
                            .animation(.default)
                        //                        TextField("", text: $typedResult, format: .)
                        TextField("?..", text: $typedResult)
                            .focused($focusedField, equals: .typedInput)
                            .keyboardType(.decimalPad)
                            .fontDesign(.rounded)
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .animation(.default)
                            .onAppear {
                                focusedField = .typedInput
                            }
                        Spacer()
                    }
                }
                
                if gameStatus == .resultsScreen {
                    VStack {
                        Text(String(score))
                            .font(.system(size: 150, weight: .heavy))
                            .rotationEffect(.degrees(resultRotation))
                            .foregroundColor(.white)
                            .shadow(color:.yellow, radius: score == totalRounds ? 30 : 0)
                            .offset(resultShake)
                            
                    }
                    .onAppear {
                        withAnimation(.spring().repeatForever()) {
                            resultRotation += 360
                        }
                        withAnimation(.spring().speed(10).repeatForever()) {
                            if resultShake.height == 5 {
                                resultShake.height -= 5
                            } else {
                                resultShake.height = 0
                            }
                        }
                    }
                }
                
                
                
                Spacer()
                
                
                
                
                Button {
                    
                    if gameStatus != .exerciseScreen {
                        getExercises(examMode: false)
                        startGame()
                        
                    } else {
                        takeExercises()
                    }
                    typedResult = ""
                    
                    getTitle()
                } label: {
                    Text(buttonTitle)
                        .font(.system(size: 20, weight: .black))
                        .frame(minWidth: 100, minHeight: 50)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 0.4, green: 0.4, blue: 1))
                
                if gameStatus == .startScreen {
                    Button {
                        
                        if gameStatus != .exerciseScreen {
                            getExercises(examMode: true)
                            startGame()
                            
                        } else {
                            takeExercises()
                        }
                        typedResult = ""
                        
                        getTitle()
                    } label: {
                        Text("Hard mode!")
                            .font(.system(size: 20, weight: .black))
                            .frame(minWidth: 100, minHeight: 50)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 1, green: 0.4, blue: 0.4))
                }
                
                
                
                
                
                
                
                    
            }
            .padding()
            .onAppear {
//                getExercises()
                getTitle()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
