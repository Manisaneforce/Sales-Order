//
//  TEST.swift
//  Sales Order
//
//  Created by San eforce on 15/05/24.
//

import SwiftUI

struct TEST: View {
    @State private var isTopWinnersVisible: Bool = true
    @State private var lastScrollOffset: CGFloat = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    Text("Winners")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                    }
                    Button(action: {}) {
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.purple)
                
                // Time Filter
                HStack {
                    Button(action: {}) {
                        Text("Today")
                            .bold()
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                    }
                    .foregroundColor(.purple)
                    
                    Button(action: {}) {
                        Text("Month")
                            .bold()
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(20)
                    }
                    .foregroundColor(.white)
                    
                    Button(action: {}) {
                        Text("All time")
                            .bold()
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(20)
                    }
                    .foregroundColor(.white)
                }
                .padding()
                .background(Color.purple)
                
                // Top Winners View with show/hide animation
                if isTopWinnersVisible {
                    TopWinnersView()
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.3), value: isTopWinnersVisible)

                }
                
                // Leaderboard Entries
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(leaderboardEntries) { entry in
                            LeaderboardEntryView(entry: entry)
                        }
                    }
                    .padding()
                    .background(GeometryReader { geo -> Color in
                        DispatchQueue.main.async {
                            let offset = geo.frame(in: .global).minY
                            print(offset)
                            print(lastScrollOffset)
                            if offset < lastScrollOffset {
                                // Scrolling up
                                withAnimation {
                                    isTopWinnersVisible = false
                                }
                            } else if offset > lastScrollOffset {
                                // Scrolling down
                                withAnimation {
                                    isTopWinnersVisible = true
                                }
                            }
                            lastScrollOffset = offset
                        }
                        return Color.clear
                    })
                }
                
                Spacer()
                
                // Bottom Navigation Bar
                HStack {
                    Image(systemName: "house.fill")
                    Spacer()
                    Image(systemName: "chart.bar.fill")
                    Spacer()
                    Image(systemName: "magnifyingglass")
                    Spacer()
                    Image(systemName: "person.fill")
                }
                .padding()
                .background(Color.white)
            }
            .background(Color.purple.edgesIgnoringSafeArea(.all))
        }
    }
}

struct TopWinnersView: View {
    var body: some View {
        HStack(spacing: 20) {
            WinnerView(imageName: "person1", name: "Tony Stark", points: 6500, position: 2)
            WinnerView(imageName: "person2", name: "Peter Parker", points: 7400, position: 1)
            WinnerView(imageName: "person3", name: "John Carter", points: 5800, position: 3)
        }
        .padding()
    }
}

struct WinnerView: View {
    let imageName: String
    let name: String
    let points: Int
    let position: Int
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .clipShape(Circle())
                .frame(width: 60, height: 60)
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                .shadow(radius: 3)
            Text(name)
                .font(.caption)
                .bold()
            Text("\(points) Pts")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}

struct LeaderboardEntryView: View {
    let entry: LeaderboardEntry
    
    var body: some View {
        HStack {
            Text("\(entry.rank)")
                .bold()
                .padding(.leading)
            Image(entry.imageName)
                .resizable()
                .clipShape(Circle())
                .frame(width: 40, height: 40)
            Text(entry.name)
                .bold()
            Spacer()
            Text("\(entry.points) Pts")
                .foregroundColor(.gray)
                .padding(.trailing)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct LeaderboardEntry: Identifiable {
    let id = UUID()
    let rank: Int
    let imageName: String
    let name: String
    let points: Int
}

let leaderboardEntries = [
    LeaderboardEntry(rank: 1, imageName: "resume", name: "Peter Parker", points: 7400),
    LeaderboardEntry(rank: 2, imageName: "resume", name: "Tony Stark", points: 6500),
    LeaderboardEntry(rank: 3, imageName: "resume", name: "John Carter", points: 5800),
    LeaderboardEntry(rank: 4, imageName: "resume", name: "Reeta Chainani", points: 5400),
    LeaderboardEntry(rank: 1, imageName: "resume", name: "Peter Parker", points: 7400),
    LeaderboardEntry(rank: 2, imageName: "resume", name: "Tony Stark", points: 6500),
    LeaderboardEntry(rank: 3, imageName: "resume", name: "John Carter", points: 5800),
    LeaderboardEntry(rank: 4, imageName: "resume", name: "Reeta Chainani", points: 5400),
    LeaderboardEntry(rank: 1, imageName: "resume", name: "Peter Parker", points: 7400),
    LeaderboardEntry(rank: 1, imageName: "resume", name: "Peter Parker", points: 7400),
    LeaderboardEntry(rank: 2, imageName: "resume", name: "Tony Stark", points: 6500),
    LeaderboardEntry(rank: 3, imageName: "resume", name: "John Carter", points: 5800),
    LeaderboardEntry(rank: 4, imageName: "resume", name: "Reeta Chainani", points: 5400),
    LeaderboardEntry(rank: 1, imageName: "resume", name: "Peter Parker", points: 7400),
    LeaderboardEntry(rank: 2, imageName: "resume", name: "Tony Stark", points: 6500),
    LeaderboardEntry(rank: 3, imageName: "resume", name: "John Carter", points: 5800),
    LeaderboardEntry(rank: 4, imageName: "resume", name: "Reeta Chainani", points: 5400),
    LeaderboardEntry(rank: 1, imageName: "resume", name: "Peter Parker", points: 7400),
    LeaderboardEntry(rank: 1, imageName: "resume", name: "Peter Parker", points: 7400),
    LeaderboardEntry(rank: 2, imageName: "resume", name: "Tony Stark", points: 6500),
    LeaderboardEntry(rank: 3, imageName: "resume", name: "John Carter", points: 5800),
    LeaderboardEntry(rank: 4, imageName: "resume", name: "Reeta Chainani", points: 5400),
    LeaderboardEntry(rank: 1, imageName: "resume", name: "Peter Parker", points: 7400),
    LeaderboardEntry(rank: 2, imageName: "resume", name: "Tony Stark", points: 6500),
    LeaderboardEntry(rank: 3, imageName: "resume", name: "John Carter", points: 5800),
    LeaderboardEntry(rank: 4, imageName: "resume", name: "Reeta Chainani", points: 5400),
    LeaderboardEntry(rank: 1, imageName: "resume", name: "Peter Parker", points: 7400),
    LeaderboardEntry(rank: 1, imageName: "resume", name: "Peter Parker", points: 7400),
    LeaderboardEntry(rank: 2, imageName: "resume", name: "Tony Stark", points: 6500),
    LeaderboardEntry(rank: 3, imageName: "resume", name: "John Carter", points: 5800),
    LeaderboardEntry(rank: 4, imageName: "resume", name: "Reeta Chainani", points: 5400),
    LeaderboardEntry(rank: 1, imageName: "resume", name: "Peter Parker", points: 7400),
    LeaderboardEntry(rank: 2, imageName: "resume", name: "Tony Stark", points: 6500),
    LeaderboardEntry(rank: 3, imageName: "resume", name: "John Carter", points: 5800),
    LeaderboardEntry(rank: 4, imageName: "resume", name: "Reeta Chainani", points: 5400),
    LeaderboardEntry(rank: 1, imageName: "resume", name: "Peter Parker", points: 7400),
    LeaderboardEntry(rank: 1, imageName: "resume", name: "Peter Parker", points: 7400),
    LeaderboardEntry(rank: 2, imageName: "resume", name: "Tony Stark", points: 6500),
    LeaderboardEntry(rank: 3, imageName: "resume", name: "John Carter", points: 5800),
    LeaderboardEntry(rank: 4, imageName: "resume", name: "Reeta Chainani", points: 5400),
    LeaderboardEntry(rank: 1, imageName: "resume", name: "Peter Parker", points: 7400),
    LeaderboardEntry(rank: 2, imageName: "resume", name: "Tony Stark", points: 6500),
    LeaderboardEntry(rank: 3, imageName: "resume", name: "John Carter", points: 5800),
    LeaderboardEntry(rank: 4, imageName: "resume", name: "Reeta Chainani", points: 5400),
    LeaderboardEntry(rank: 1, imageName: "resume", name: "Peter Parker", points: 7400),
    LeaderboardEntry(rank: 14, imageName: "resume", name: "Satwik Pachino", points: 3684)
]

