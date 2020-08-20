
/* Class: Game */
/* Manage the game board and other parameters. */

import Foundation

public class Game {
    
    var board: [[BoardCellDisc]]
    var currentColor: BoardCellDiscColor
    let ai: Bool
    
    init(ai: Bool) {
        board = [[BoardCellDisc]]()
        currentColor = .blue
        self.ai = ai
        
        initBoard()
    }
    
    // Initialize game's board
    func initBoard() {
        for _ in 0...5 {
            var row = [BoardCellDisc]()
            for _ in 0...6 {
                row.append(BoardCellDisc())
            }
            board.append(row)
        }
    }
    
    // Get first free row of the board (from bottom to top)
    func getFirstFreeRow(column: Int) -> Int {
        for row in 0...5 {
            if board[5 - row][column].color == .none {
                return 5 - row
            }
        }
        return -1
    }
    
    // Drop a disc in a column
    func dropDisc(column: Int) {
        for row in 0...5 {
            if board[5 - row][column].color == .none {
                board[5 - row][column].switchColorAnimated(color: currentColor)
                break
            }
        }
    }
    
    // Simulate disc drop
    func aiDropDisc(color: BoardCellDiscColor, column: Int) {
        for row in 0...5 {
            if board[5 - row][column].color == .none {
                board[5 - row][column].color = color
                break
            }
        }
    }
    
    // Undo simulated disc drop
    func aiUndoDropDisc(column: Int) {
        for row in 0...5 {
            if board[row][column].color != .none {
                board[row][column].color = .none
                break
            }
        }
    }
    
    // Returns the current color if such has won the game
    func playerHasWon() -> BoardCellDiscColor {
        return playerWins(color: currentColor, toCheck: 4)
    }
    
    // Returns the color passed as an argument if such has toCheck discs lined up
    func playerWins(color: BoardCellDiscColor, toCheck: Int) -> BoardCellDiscColor {
        var check = 0
        
        // Horizontal
        for row in 0...5 {
            for i in 0...3 {
                check = 0
                for j in 0...3 {
                    if board[row][i+j].color == color {
                        check += 1
                    }
                }
                if check == toCheck {
                    for j in 0...3 {
                        board[row][i+j].win = true
                    }
                    return color
                }
            }
        }
        
        // Vertical
        for column in 0...6 {
            for i in 0...2 {
                check = 0
                for j in 0...3 {
                    if board[i+j][column].color == color {
                        check += 1
                    }
                }
                if check == toCheck {
                    for j in 0...3 {
                        board[i+j][column].win = true
                    }
                    return color
                }
            }
        }
        
        // Diagonal (left)
        for i in 0...3 {
            for j in 0...2 {
                check = 0
                for k in 0...3 {
                    if board[j+k][i+k].color == color {
                        check += 1
                    }
                }
                if check == toCheck {
                    for k in 0...3 {
                        board[j+k][i+k].win = true
                    }
                    return color
                }
            }
        }
        
        // Diagonal (right)
        for i in 3...5 {
            for j in 0...3 {
                check = 0
                for k in 0...3 {
                    if board[i-k][j+k].color == color {
                        check += 1
                    }
                }
                if check == toCheck {
                    for k in 0...3 {
                        board[i-k][j+k].win = true
                    }
                    return color
                }
            }
        }
        
        return .none
    }
    
    // Reset win attribute of all discs on each turn
    func clearWinDiscs() {
        for i in 0...5 {
            for j in 0...6 {
               board[i][j].win = false
            }
        }
    }
    
    // Returns true if the board is full
    func tieHasHappened() -> Bool {
        for i in 0...5 {
            for j in 0...6 {
                if board[i][j].color == .none {
                    return false
                }
            }
        }
        return true
    }
    
    // Chooses a column for the AI to drop a disc in
    func playAI() -> Int {
        
        // AI Win
        for column in 0...6 {
            if !columnIsFull(column: column) {
                aiDropDisc(color: currentColor, column: column)
                let aiWins = playerHasWon()
                aiUndoDropDisc(column: column)
                if aiWins == currentColor && Int(arc4random_uniform(15)) != 1 {
                    return column
                }
            }
        }
        
        // Avoid human's win
        for column in 0...6 {
            if !columnIsFull(column: column) {
                aiDropDisc(color: .blue, column: column)
                let humanWins = playerWins(color: .blue, toCheck: 4)
                aiUndoDropDisc(column: column)
                if humanWins == .blue && Int(arc4random_uniform(13)) != 1 {
                    return column
                }
            }
        }
        
        // Avoid letting human win
        for column in 0...6 {
            if !columnIsFull(column: column) {
                aiDropDisc(color: .red, column: column)
                for columnHuman in 0...6 {
                    if !columnIsFull(column: columnHuman) {
                        aiDropDisc(color: .blue, column: columnHuman)
                        let humanWins = playerWins(color: .blue, toCheck: 4)
                        aiUndoDropDisc(column: columnHuman)
                        if humanWins == .blue && Int(arc4random_uniform(11)) != 1 {
                            aiUndoDropDisc(column: column)
                            return anyColumn(but: column)
                        }
                    }
                }
                aiUndoDropDisc(column: column)
            }
        }
        
        // Make a move
        for column in 0...6 {
            if !columnIsFull(column: column) {
                aiDropDisc(color: .red, column: column)
                for columnAI in 0...6 {
                    if !columnIsFull(column: columnAI) {
                        aiDropDisc(color: .red, column: columnAI)
                        let aiWins = playerWins(color: .red, toCheck: 4)
                        aiUndoDropDisc(column: columnAI)
                        if aiWins == .red && Int(arc4random_uniform(8)) != 1 {
                            aiUndoDropDisc(column: column)
                            return column
                        }
                    }
                }
                aiUndoDropDisc(column: column)
            }
        }
        
        // Avoid human's possible win
        for column in 0...6 {
            if !columnIsFull(column: column) {
                aiDropDisc(color: .blue, column: column)
                let humanCouldWin = playerWins(color: .blue, toCheck: 3)
                aiUndoDropDisc(column: column)
                if humanCouldWin == .blue && Int(arc4random_uniform(3)) != 1 {
                    return column
                }
            }
        }
        
        // Any column
        return anyColumn()
 
    }
    
    // Returns a random column
    func anyColumn() -> Int {
        var column = Int(arc4random_uniform(7))
        while columnIsFull(column: column) {
            column = Int(arc4random_uniform(7))
        }
        
        return column
    }
    
    // Returns a random column but the specified
    func anyColumn(but: Int) -> Int {
        var column = Int(arc4random_uniform(7))
        var num = 0
        while (columnIsFull(column: column) || column == but) && num < 500 {
            column = Int(arc4random_uniform(7))
            num += 1
        }
        
        if num == 500 {
            return anyColumn()
        }
        
        return column
    }
    
    // Switches between the blue and red colors
    func switchCurrentColor() {
        switch currentColor {
            case .blue:
                currentColor = .red; break
            case .red:
                currentColor = .blue; break
            default:
                currentColor = .none; break
        }
    }
    
    // Preview disc drop when selecting a column
    func previewDiscColorSwitch(column: Int) {
        board[getFirstFreeRow(column: column)][column].previewColorSwitch(color: currentColor)
    }
    
    // Undo disc drop preview
    func undoPreviewDiscColorSwitch(column: Int) {
        board[getFirstFreeRow(column: column)][column].previewColorSwitch(color: .none)
    }
    
    // Returns true if the specified column is full
    func columnIsFull(column: Int) -> Bool {
        for i in 0...5 {
            if board[i][column].color == .none {
                return false
            }
        }
        return true
    }
    
}
