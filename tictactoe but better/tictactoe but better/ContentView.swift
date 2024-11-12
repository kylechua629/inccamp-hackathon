//
//  ContentView.swift
//  tictactoe but better
//
//  Created by Lim Zhe Hsien on 12/11/24.
//
 import SwiftUI

struct ContentView: View {
    @State private var board: [[String]] = Array(repeating: Array(repeating: "", count: 5), count: 5)
    @State private var currentPlayer: String = "X"
    @State private var gameOver: Bool = false
    @State private var winner: String? = nil

    var body: some View {
        VStack {
            Text("5x5 Tic-Tac-Toe")
                .font(.largeTitle)
                .padding()

            Spacer()

            VStack(spacing: 5) {
                ForEach(0..<5, id: \.self) { row in
                    HStack(spacing: 5) {
                        ForEach(0..<5, id: \.self) { column in
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
        // Check rows, columns, and diagonals for 5 in a row
        let winCondition = 5

        // Check rows
        for row in 0..<5 {
            for start in 0...(5 - winCondition) {
                if board[row][start...(start + winCondition - 1)].allSatisfy({ $0 == player }) {
                    return true
                }
            }
        }

        // Check columns
        for column in 0..<5 {
            for start in 0...(5 - winCondition) {
                if (start..<(start + winCondition)).allSatisfy({ board[$0][column] == player }) {
                    return true
                }
            }
        }

        // Check diagonals (top-left to bottom-right)
        for row in 0...(5 - winCondition) {
            for column in 0...(5 - winCondition) {
                if (0..<winCondition).allSatisfy({ board[row + $0][column + $0] == player }) {
                    return true
                }
            }
        }

        // Check diagonals (bottom-left to top-right)
        for row in (winCondition - 1)..<5 {
            for column in 0...(5 - winCondition) {
                if (0..<winCondition).allSatisfy({ board[row - $0][column + $0] == player }) {
                    return true
                }
            }
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
        board = Array(repeating: Array(repeating: "", count: 5), count: 5)
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
                .frame(width: 60, height: 60)
                .cornerRadius(5)
            
            Text(symbol)
                .font(.system(size: 30))
                .foregroundColor(.white)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
