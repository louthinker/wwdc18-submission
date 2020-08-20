
/* Class: GameView */
/* View of the game in progress. */

import UIKit
import PlaygroundSupport
import XCPlayground
import AVFoundation

public class GameView : UIView {
    
    var game: Game
    let viewWidth: CGFloat = 500.0
    let viewHeight: CGFloat = 500.0
    let topTextLabel: MyLabel
    let audioPlayer: MyAudio
    
    // Buttons
    var columnsButtons: [UIButton]
    let exitButton: UIButton
    let exitButtonSmall: UIButton
    let exitButtonSmallImage: UIImageView
    
    // Player Images
    let bluePlayer: UIImageView
    let redPlayer: UIImageView
    
    // Animators
    var animateColumnPress: UIViewPropertyAnimator
    var animateColumnPressEnd: UIViewPropertyAnimator
    var animateCurrentPlayer: UIViewPropertyAnimator
    var animatePreviousPlayer: UIViewPropertyAnimator
    var animateBluePlayer: UIViewPropertyAnimator
    var animateRedPlayer: UIViewPropertyAnimator
    var animateDisc: UIViewPropertyAnimator
    
    public init(ai: Bool) {
        
        game = Game(ai: ai)
        columnsButtons = [UIButton]()
        exitButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 500.0, height: 500.0))
        exitButtonSmall = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 84.0, height: 84.0))
        exitButtonSmallImage = UIImageView(frame: CGRect(x: 22.0, y: 20.0, width: 44.0, height: 44.0))
        topTextLabel = MyLabel(x: 0, y: 0, w: 500, h: 80, size: 28, text: "Prueba")
        audioPlayer = MyAudio()
        
        animateColumnPress = UIViewPropertyAnimator()
        animateColumnPressEnd = UIViewPropertyAnimator()
        animateCurrentPlayer = UIViewPropertyAnimator()
        animatePreviousPlayer = UIViewPropertyAnimator()
        animateBluePlayer = UIViewPropertyAnimator()
        animateRedPlayer = UIViewPropertyAnimator()
        animateDisc = UIViewPropertyAnimator()
        
        bluePlayer = UIImageView(frame: CGRect(x: 194.0, y: 20.0, width: 44.0, height: 44.0))
        redPlayer = UIImageView(frame: CGRect(x: 262.0, y: 20.0, width: 44.0, height: 44.0))
        
        super.init(frame:  CGRect(x: 0, y: 0, width: self.viewWidth, height: self.viewHeight))
        self.setUpView()
        
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    // Set up the view's elements
    func setUpView() {
        self.backgroundColor = UIColor(patternImage: UIImage(named: "ViewBackground.png")!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.setUpBoard()
            self.addTopTextLabel()
            self.addColumnsButtons()
            self.addPlayerImages()
            self.switchCurrentPlayer()
            self.addExitButton()
        })
    }
    
    // Set up the game's board
    func setUpBoard() {
        let discWidth = game.board[0][0].discWidth
        let betweenDiscs = (viewWidth - discWidth * 7.0) / 10.0
        let initialX = betweenDiscs * 2.0
        let initialY = viewWidth - initialX - (discWidth * 6.0) - betweenDiscs * 5.0
        var s = 0.0
        for i in 0...5 {
            for j in 0...6 {
                let x = initialX + (discWidth + betweenDiscs) * CGFloat(j)
                let y = initialY + (discWidth + betweenDiscs) * CGFloat(i)
                game.board[i][j].imageView.frame.origin.x = x
                game.board[i][j].imageView.frame.origin.y = y
                self.addSubview(game.board[i][j].imageView)
                DispatchQueue.main.asyncAfter(deadline: .now() + s, execute: {
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 0.3,
                        delay: 0.0,
                        options: [ .curveEaseInOut ],
                        animations: {
                            self.game.board[i][j].imageView.alpha = 1.0
                            self.game.board[i][j].imageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                        }).addCompletion({ _ in
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.3,
                                delay: 0.0,
                                options: [ .curveEaseInOut ],
                                animations: {
                                    self.game.board[i][j].imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                            })
                    })
                })
                s += 0.1
            }
            s -= 0.62
        }
    }
    
    // Add the top text label to the view
    func addTopTextLabel() {
        topTextLabel.alpha = 0.0
        topTextLabel.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        self.addSubview(topTextLabel)
    }
    
    // Edit the top text label
    func editTopTextLabel(color: BoardCellDiscColor) {
        switch color {
            case .blue:
                if game.ai {
                    topTextLabel.text = "You win!"
                } else {
                    topTextLabel.text = "Blue player wins!"
                }
                topTextLabel.textColor = UIColor(red: 0.24, green: 0.61, blue: 0.95, alpha: 1.0)
                break
            case .red:
                if game.ai {
                    topTextLabel.text = "AI wins!"
                } else {
                    topTextLabel.text = "Red player wins!"
                }
                topTextLabel.textColor = UIColor(red: 0.96, green: 0.38, blue: 0.38, alpha: 1.0)
                break
            default:
                topTextLabel.text = "Tie!"
                break
        }
    }
    
    // Animate the top text label
    func animateTopTextLabel() {
        UIView.animate(
            withDuration: 0.9,
            delay: 0.5,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                self.topTextLabel.alpha = 1.0
                self.topTextLabel.transform = .identity
        }, completion: nil)
    }
    
    // Add a button to each column of the board
    func addColumnsButtons() {
        let discWidth = game.board[0][0].discWidth
        let betweenDiscs = (viewWidth - discWidth * 7.0) / 10.0
        let initialX = betweenDiscs * 2.0
        let posY = viewWidth - initialX - (discWidth * 6.0) - betweenDiscs * 5.0
        let height = discWidth * 6.0 + betweenDiscs * 5.0
        
        for i in 0...6 {
            let posX = initialX + (discWidth + betweenDiscs) * CGFloat(i)
            let button = UIButton(frame: CGRect(x: posX, y: posY, width: discWidth, height: height))
            columnsButtons.append(button)
            button.tag = i
            button.isExclusiveTouch = true
            button.addTarget(self, action: #selector(selectColumnAction), for: .touchDown)
            button.addTarget(self, action: #selector(deselectColumn), for: .touchDragOutside)
            button.addTarget(self, action: #selector(pressColumnAction), for: .touchUpInside)
            self.addSubview(button)
        }
    }
    
    @objc func selectColumnAction(sender: UIButton) {
        selectColumn(column: sender.tag)
    }
    
    // Animate column deselection
    @objc func deselectColumn(sender: UIButton) {
        game.undoPreviewDiscColorSwitch(column: sender.tag)
        animateColumnPressEnd.startAnimation()
    }
    
    @objc func pressColumnAction(sender: UIButton) {
        pressColumn(column: sender.tag)
    }
    
    // Animate column selection
    func selectColumn(column: Int) {
        if !game.columnIsFull(column: column) {
            if game.currentColor == .blue || game.ai == false {
                game.previewDiscColorSwitch(column: column)
            }
            audioPlayer.playSoundSelectColumn()
            createAnimationColumnPress(index: column)
            animateColumnPress.startAnimation()
        }
    }
    
    // Button: press column and drop disc in such column
    func pressColumn(column: Int) {
        if !game.columnIsFull(column: column) {
            audioPlayer.playSoundDropDisc()
            game.dropDisc(column: column)
            animateColumnPressEnd.startAnimation()
            let player = game.playerHasWon()
            if player != .none {
                gameWon()
            } else {
                game.clearWinDiscs()
                if game.tieHasHappened() {
                    gameTied()
                } else {
                    game.switchCurrentColor()
                    switchCurrentPlayer()
                    if game.ai && game.currentColor == .red {
                        playAI()
                    }
                }
            }
        }
    }
    
    // Play the AI's turn
    func playAI() {
        disableButtons()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            let column = self.game.playAI()
            self.selectColumn(column: column)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.pressColumn(column: column)
                self.enableButtons()
            })
        })
    }
    
    // Create the animation for pressing the column
    func createAnimationColumnPress(index: Int) {
        animateColumnPress = UIViewPropertyAnimator(duration: 0.14, curve: .easeOut) {
            for i in 0...5 {
                self.game.board[i][index].imageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        }
        animateColumnPressEnd = UIViewPropertyAnimator(duration: 0.1, curve: .easeOut) {
            for i in 0...5 {
                self.game.board[i][index].imageView.transform = CGAffineTransform.identity
            }
        }
    }
    
    // Create the animations for the player icons at the top
    func createAnimationCurrentPlayer() {
        if game.currentColor == .blue {
            bluePlayer.alpha = 1.0
            animateCurrentPlayer = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.3) {
                self.bluePlayer.transform = CGAffineTransform.identity
            }
            animatePreviousPlayer = UIViewPropertyAnimator(duration: 0.4, curve: .easeOut) {
                self.redPlayer.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.redPlayer.alpha = 0.3
            }
        } else {
            redPlayer.alpha = 1.0
            animateCurrentPlayer = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.3) {
                self.redPlayer.transform = CGAffineTransform.identity
            }
            animatePreviousPlayer = UIViewPropertyAnimator(duration: 0.4, curve: .easeOut) {
                self.bluePlayer.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.bluePlayer.alpha = 0.3
            }
        }
    }
    
    // Initialize the player icons
    func initPlayerImages() {
        bluePlayer.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        redPlayer.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        bluePlayer.alpha = 0.0
        redPlayer.alpha = 0.0
        bluePlayer.image = UIImage(named: "Players/BluePlayer-Happy.png")
        if game.ai {
            redPlayer.image = UIImage(named: "Players/AI-Happy.png")
        } else {
            redPlayer.image = UIImage(named: "Players/RedPlayer-Happy.png")
        }
        animateBluePlayer = UIViewPropertyAnimator(duration: 1.0, curve: .easeOut) {
            self.bluePlayer.transform = CGAffineTransform.identity
        }
        animateRedPlayer = UIViewPropertyAnimator(duration: 1.0, curve: .easeOut) {
            self.redPlayer.transform = CGAffineTransform.identity
        }
    }
    
    // Add the player icons to the view
    func addPlayerImages() {
        initPlayerImages()
        self.addSubview(bluePlayer)
        self.addSubview(redPlayer)
        animateBluePlayer.startAnimation()
        animateRedPlayer.startAnimation()
    }
    
    // Animate player icons on tie
    func animatePlayersOnTie() {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.42,
            delay: 0.0,
            options: [ .curveEaseOut ],
            animations: {
                self.bluePlayer.transform = CGAffineTransform.identity
                self.bluePlayer.alpha = 1.0
                self.redPlayer.transform = CGAffineTransform.identity
                self.redPlayer.alpha = 1.0
                self.exitButtonSmallImage.alpha = 0.0
        })
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.8,
            delay: 0.0,
            options: [ .curveEaseInOut ],
            animations: {
                self.bluePlayer.frame = self.bluePlayer.frame.offsetBy(dx: -170.0, dy: 0.0)
                self.redPlayer.frame = self.redPlayer.frame.offsetBy(dx: 170.0, dy: 0.0)
        })
    }
    
    // Enable columns' buttons
    func enableButtons() {
        for button in columnsButtons {
            button.isEnabled = true
        }
    }
    
    // Disable columns' buttons
    func disableButtons() {
        for button in columnsButtons {
            button.isEnabled = false
        }
    }
    
    // Animate win
    func gameWon() {
        for button in columnsButtons {
            button.isEnabled = false
        }
        editTopTextLabel(color: game.currentColor)
        if game.currentColor == .blue {
            bluePlayer.image = UIImage(named: "Players/BluePlayer-Win.png")
            if game.ai {
                redPlayer.image = UIImage(named: "Players/AI-Loss.png")
            } else {
                redPlayer.image = UIImage(named: "Players/RedPlayer-Loss.png")
            }
        } else {
            bluePlayer.image = UIImage(named: "Players/BluePlayer-Loss.png")
            if game.ai {
                redPlayer.image = UIImage(named: "Players/AI-Win.png")
            } else {
                redPlayer.image = UIImage(named: "Players/RedPlayer-Win.png")
            }
        }
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.42,
            delay: 0.0,
            options: [ .curveEaseOut ],
            animations: {
                self.exitButtonSmallImage.alpha = 0.0
        })
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.8,
            delay: 0.0,
            options: [ .curveEaseInOut ],
            animations: {
                self.bluePlayer.frame = self.bluePlayer.frame.offsetBy(dx: -170.0, dy: 0.0)
                self.redPlayer.frame = self.redPlayer.frame.offsetBy(dx: 170.0, dy: 0.0)
        })
        audioPlayer.playSoundEnd()
        animateTopTextLabel()
        fourDiscs()
        exitButton.isEnabled = true
    }
    
    // Animate tie
    func gameTied() {
        bluePlayer.image = UIImage(named: "Players/BluePlayer-Win.png")
        if game.ai {
            redPlayer.image = UIImage(named: "Players/AI-Win.png")
        } else {
            redPlayer.image = UIImage(named: "Players/RedPlayer-Win.png")
        }
        editTopTextLabel(color: .none)
        animatePlayersOnTie()
        audioPlayer.playSoundEnd()
        animateTopTextLabel()
        exitButton.isEnabled = true
    }
    
    // Animate the discs that have caused the win
    func fourDiscs() {
        animateDisc = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            for i in 0...5 {
                for j in 0...6 {
                    if self.game.board[i][j].win == true {
                        self.game.board[i][j].imageView.alpha = 0.6
                    }
                }
            }
        }
        animateDisc.addCompletion { (UIViewAnimatingPosition) in
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.3,
                delay: 0.0,
                options: [ .curveEaseInOut ],
                animations: {
                    for i in 0...5 {
                        for j in 0...6 {
                            if self.game.board[i][j].win == true {
                                self.game.board[i][j].imageView.alpha = 1.0
                            }
                        }
                    }
            }).addCompletion({ _ in
                self.fourDiscs()
            })
        }
        animateDisc.startAnimation()
    }
    
    // Add an exit button to the view
    func addExitButton() {
        exitButton.isEnabled = false
        exitButton.addTarget(self, action: #selector(exitGame), for: .touchDown)
        self.addSubview(exitButton)
        
        exitButtonSmallImage.alpha = 0.0
        exitButtonSmallImage.image = UIImage(named: "ExitArrow.png")
        exitButtonSmall.addTarget(self, action: #selector(exitGame), for: .touchDown)
        self.addSubview(exitButtonSmall)
        self.addSubview(exitButtonSmallImage)
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 1.0,
            delay: 0.3,
            options: [ .curveEaseInOut ],
            animations: {
                self.exitButtonSmallImage.alpha = 1.0
        })
    }
    
    // Button: exit to the menu
    @objc func exitGame() {
        audioPlayer.playSoundExit()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            UIView.transition(from: self, to: MenuView(), duration: 0.3, options: [ .transitionCrossDissolve ])
        })
    }
    
    // Switch player icons states
    func switchCurrentPlayer() {
        createAnimationCurrentPlayer()
        animateCurrentPlayer.startAnimation()
        animatePreviousPlayer.startAnimation()
    }
    
}
