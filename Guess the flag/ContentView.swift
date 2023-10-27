//
//  ContentView.swift
//  Guess the flag
//
//  Created by Peter Sederblad on 2023-09-25.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var playerScore = 0
    @State private var questionsAsked = 0
    @State private var gameOver = false
    @State private var showingGameOverAlert = false
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                Spacer()
                Spacer()
                Text("\(playerScore)")
                Spacer()
                    .foregroundColor(.white)
                    .font(.title.bold())
                VStack(spacing: 15) {
                    VStack {
                        Text("tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                }
                
                ForEach(0..<3) { number in
                    Button {
                        flagTapped(number)
                    } label: {
                        Image(countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            if questionsAsked < 7 {
                Text("This is round \(questionsAsked + 1). Your score is \(playerScore), The right country was alternative \(correctAnswer + 1)")
            } else if questionsAsked == 7 {
                Text("You have reached 8 rounds. Game over. ")
                
            }
        }
    }
        
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            playerScore += 1
        } else {
            scoreTitle = "Wrong"
            if playerScore < 0 {
                playerScore -= 1
            }
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionsAsked += 1
        if questionsAsked == 8 {
            showingGameOverAlert = true
            resetGame()
        }
    }
    
    func resetGame() {
        playerScore = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionsAsked = 0
    }
}


    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
