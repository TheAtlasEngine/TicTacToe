//
//  BoardView.swift
//  TicTacToe
//
//  Created by Kosuke Nishimura on 2023/03/25.
//

import SwiftUI

struct BoardView: View {
    
    @ObservedObject var board = Board()
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            if board.didFinishGame {
                resetButton
                    .padding(.bottom, 20)
            }
            gameInfoView
                .font(.title)
                .padding(.bottom, 20)
            Grid {
                GridRow {
                    Color.clear
                        .gridCellUnsizedAxes([.horizontal, .vertical])
                    ForEach(0..<board.size, id: \.self) { column in
                        Text("\(column)")
                    }
                }
                ForEach(0..<board.size, id: \.self) { row in
                    GridRow {
                        Text("\(row)")
                        ForEach(0..<board.size, id: \.self) { column in
                            Button {
                                board.tapSquare(at: .init(row: row, column: column))
                            } label: {
                                square(
                                    mark: mark(at: .init(row: row, column: column))
                                )
                            }
                            .foregroundColor(.black)
                        }
                    }
                }
            }
            Spacer()
                .frame(height: 200)
        }
    }
    
    func square(mark: String) -> some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: 70, height: 70)
            .border(Color.gray)
            .overlay {
                Text(mark)
                    .font(.system(size: 18, weight: .thin))
            }
    }
    
    func mark(at index: BoardIndex) -> String {
        board.square(at: index)?.value ?? "nil"
    }
    
    @ViewBuilder
    var gameInfoView: some View {
        if let result = board.result {
            Text(result.description)
        } else {
            Text("Current Player is " + board.player)
        }
    }
    
    var resetButton: some View {
        Button {
            board.reset()
        } label: {
            Text("Reset")
                .font(.title)
        }
    }
    
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}

