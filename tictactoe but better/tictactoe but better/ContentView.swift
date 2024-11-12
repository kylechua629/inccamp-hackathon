//
//  ContentView.swift
//  tictactoe but better
//
//  Created by Lim Zhe Hsien on 12/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var board: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    @State private var currentPlayer: String = "X"
    @State private var gameOver: Bool = false
    @State private var winner: String? = nil

    var body: some View {
        VStack {
            Text("Tic-Tac-Toe")
                .font(.largeTitle)
                .padding()

            Spacer()

            VStack(spacing: 10) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(0..<3, id: \.self) { column in
                            CellView(symbol: $board[row][column])
                                .onTapGesture {
                                    makeMove(row: row, column: column)
                                }
                        }
                    }
                }
            }

            Spacer()

            if gameOver {
                Text(winnerMessage())
                    .font(.headline)
                    .padding()

                Button("Play Again") {
                    resetGame()
                }
                .padding()
            }
        }
        .padding()
    }

    private func makeMove(row: Int, column: Int) {
        guard board[row][column].isEmpty, !gameOver else { return }

        board[row][column] = currentPlayer
        if checkWin(for: currentPlayer) {
            winner = currentPlayer
            gameOver = true
        } else if isBoardFull() {
            gameOver = true
        } else {
            currentPlayer = currentPlayer == "X" ? "O" : "X"
        }
    }

    private func checkWin(for player: String) -> Bool {
        // Check rows and columns
        for i in 0..<3 {
            if board[i][0] == player && board[i][1] == player && board[i][2] == player {
                return true
            }
            if board[0][i] == player && board[1][i] == player && board[2][i] == player {
                return true
            }
        }

        // Check diagonals
        if board[0][0] == player && board[1][1] == player && board[2][2] == player {
            return true
        }
        if board[0][2] == player && board[1][1] == player && board[2][0] == player {
            return true
        }

        return false
    }

    private func isBoardFull() -> Bool {
        for row in board {
            if row.contains("") {
                return false
            }
        }
        return true
    }

    private func winnerMessage() -> String {
        if let winner = winner {
            return "\(winner) wins!"
        } else {
            return "It's a draw!"
        }
    }

    private func resetGame() {
        board = Array(repeating: Array(repeating: "", count: 3), count: 3)
        currentPlayer = "X"
        gameOver = false
        winner = nil
    }
}

struct CellView: View {
    @Binding var symbol: String

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blue)
                .frame(width: 100, height: 100)
                .cornerRadius(10)
            
            Text(symbol)
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
}

#Preview{
    ContentView()
}
