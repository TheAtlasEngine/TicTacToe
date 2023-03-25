//
//  Models.swift
//  TicTacToe
//
//  Created by Kosuke Nishimura on 2023/03/25.
//

import Combine
import Foundation

final class Board: ObservableObject {
    
    let size = 4
    
    @Published private var squares: [BoardIndex: Square]
    @Published private var currentPlayer: Player
    
    @Published private(set) var result: GameResult?
    
    init() {
        
        let indices = BoardIndex.allIndices(size: size)
        let pairs = indices.map { ($0, Square(index: $0, mark: .void)) }
        self.squares = .init(uniqueKeysWithValues: pairs)
        
        self.currentPlayer = .o
        
    }
    
    var player: String {
        currentPlayer.rawValue
    }
    
    var didFinishGame: Bool {
        result != nil
    }
    
    func square(at index: BoardIndex) -> Square? {
        squares[index]
    }
    
    func tapSquare(at index: BoardIndex) {
        
        guard result == nil else {
            return
        }
        
        guard squares[index]?.mark == .void else {
            return
        }
        
        switch currentPlayer {
        case .o:
            squares[index] = .init(index: index, mark: .o)
            updateResult()
            if result ==  nil {
                currentPlayer = .x
            }
        case .x:
            squares[index] = .init(index: index, mark: .x)
            updateResult()
            if result == nil {
                currentPlayer = .o
            }
        }
        
    }
    
    func reset() {
        
        let indices = BoardIndex.allIndices(size: size)
        let pairs = indices.map { ($0, Square(index: $0, mark: .void)) }
        self.squares = .init(uniqueKeysWithValues: pairs)
        
        self.currentPlayer = .o
        self.result = nil
        
    }
    
}

private extension Board {
    
    func updateResult() {
        
        if isCompleted() {
            result = .win(currentPlayer)
            return
        }
        
        if squares.filter({ index, square in square.mark == .void }).isEmpty {
            result = .stalemate
            return
        }
        
    }
    
    func isCompleted() -> Bool {
        
        var result: [Bool] = [isCompletedDiagonal()]
        
        for s in 0..<size {
            result.append(isCompleted(atRow: s) || isComleted(atColumn: s))
        }
        
        return result.contains(true)
        
    }
    
    func isCompleted(atRow row: Int) -> Bool {
        squares
            .filter { index, square in
                index.row == row && square.mark == currentPlayer.mark
            }
            .count == size
    }
    
    func isComleted(atColumn column: Int) -> Bool {
        squares
            .filter { index, square in
                index.column == column && square.mark == currentPlayer.mark
            }
            .count == size
    }
    
    func isCompletedDiagonal() -> Bool {
        let isCompletedDiag1 = squares
            .filter { index, square in
                index.row == index.column && square.mark == currentPlayer.mark
            }
            .count == size
        
        let isCompletedDiag2 = squares
            .filter { index, square in
                index.row == (size - index.column - 1) && square.mark == currentPlayer.mark
            }
            .count == size
        
        return isCompletedDiag1 || isCompletedDiag2
    }
    
}

struct Square: Identifiable {
    
    let index: BoardIndex
    let mark: Mark
    
    var id: BoardIndex {
        index
    }
    
    var value: String  {
        mark.rawValue
    }
    
}

struct BoardIndex: Hashable {
    
    let row: Int
    let column: Int
    
    static func allIndices(size: Int) -> [BoardIndex] {
        
        let rows = Array(0..<size)
        let columns = Array(0..<size)
        
        var indices: [BoardIndex] = []
        
        for r in rows {
            for c in columns {
                indices.append(BoardIndex(row: r, column: c))
            }
        }
        
        return indices
        
    }
    
}

enum Mark: String {
    case o = "o"
    case x = "x"
    case void = ""
}

enum Player: String {
    case o = "O"
    case x = "X"
    
    var mark: Mark {
        switch self {
        case .o:
            return .o
        case .x:
            return .x
        }
    }
}

enum GameResult {
    case win(Player)
    case stalemate
    
    var description: String {
        switch self {
        case .win(let player):
            return "Player \(player.rawValue) Win"
        case .stalemate:
            return "Stalemate"
        }
    }
}
