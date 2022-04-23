//
//  ContentView.swift
//  Flagnation
//
//  Created by Bern N on 2/21/22.
//

import SwiftUI

struct FlagImage: View {
    var source: String
    
    var body: some View {
        Image(source)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var numQuestions = 1
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var scorePercentage = 0.0
    @State private var showingScore = false
    @State private var endGame = false
    
    var score: String {
        let scoreAmount = scorePercentage
        let formattedScore = String(format: "%.1f" ,scoreAmount)
        return formattedScore
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                Gradient.Stop(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                Gradient.Stop(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 1)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Flagnation")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    ForEach(0..<3) { flagNumber in
                        Button {
                            flagTapped(flagNumber)
                        } label: {
                            FlagImage(source: countries[flagNumber])
                        }
                    }
                }
                
                Spacer()
                Spacer()
                
                Text("Question \(numQuestions) of 8")
                    .font(.headline)
                
                Spacer()
                
                Text("Current Score:")
                    .font(.subheadline.weight(.heavy))
                    .foregroundStyle(.primary)
                
                Text("\(score)%")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("""
                 \(scoreMessage)
                 Your current score is \(score)%.
                 """)
        }
        .alert(scoreTitle, isPresented: $endGame) {
            Button("Reset", action: reset)
        } message: {
            Text("You score a total of \(score)%.")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            scoreMessage = "Nicely done! 👏"
            scorePercentage += 12.5
        } else {
            scoreTitle = "Wrong"
            scoreMessage = "Nope, that's actually the flag of \(countries[number])."
        }
        
        showingScore = true
        
        if numQuestions == 8 {
            endGame = true
            scoreTitle = "Your Results"
        }
    }
    
    func askQuestion() {
        if numQuestions < 8 {
            numQuestions += 1
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
    }
    
    func reset() {
        numQuestions = 1
        scorePercentage = 0.0
        showingScore = false
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
