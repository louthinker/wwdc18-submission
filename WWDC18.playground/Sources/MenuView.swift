
/* Class: MenuView */
/* Title and menu of the game. */

import UIKit
import PlaygroundSupport
import XCPlayground

public class MenuView : UIView {
    
    let audioPlayer: MyAudio
    
    // Title
    let titleLabel: MyLabel
    let blueCircle: UIImageView
    let redCircle: UIImageView
    
    // Buttons
    let aiModeButton: UIButton
    let twoPlayerModeButton: UIButton
    
    // Title Animator
    var animateTitleLabel: UIViewPropertyAnimator
    
    public init() {
        
        audioPlayer = MyAudio()
        titleLabel = MyLabel(x: 0, y: 0, w: 500, h: 500, size: 40, text: "Connect Four")
        animateTitleLabel = UIViewPropertyAnimator()
        blueCircle = UIImageView(frame: CGRect(x: 60.0, y: 243.0, width: 20.0, height: 20.0))
        redCircle = UIImageView(frame: CGRect(x: 420.0, y: 243.0, width: 20.0, height: 20.0))
        aiModeButton = UIButton(frame: CGRect(x: 150.0, y: 300.0, width: 200.0, height: 60.0))
        twoPlayerModeButton = UIButton(frame: CGRect(x: 150.0, y: 385.0, width: 200.0, height: 60.0))
        
        super.init(frame:  CGRect(x: 0, y: 0, width: 500, height: 500))
        initTitleLabel()
        initButtons()
        setUpView()
        runView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.audioPlayer.playSoundStart()
        })
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    // Initialize title elements
    func initTitleLabel() {
        titleLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        titleLabel.alpha = 0.0
        
        blueCircle.image = UIImage(named: "Discs/BlueDisc.png")
        redCircle.image = UIImage(named: "Discs/RedDisc.png")
        blueCircle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        redCircle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        blueCircle.alpha = 0.0
        redCircle.alpha = 0.0
        
        initTitleAnimator()
    }
    
    // Add title elements to view
    func addTitleLabel() {
        self.addSubview(titleLabel)
        self.addSubview(blueCircle)
        self.addSubview(redCircle)
    }
    
    // Initialize game modes buttons
    func initButtons() {
        aiModeButton.alpha = 0.0
        aiModeButton.isEnabled = false
        aiModeButton.setTitle("2-player Mode", for: .normal)
        aiModeButton.setTitleColor(.white, for: .normal)
        aiModeButton.backgroundColor = UIColor(red: 0.24, green: 0.61, blue: 0.95, alpha: 1.0)
        aiModeButton.layer.cornerRadius = 14
        aiModeButton.clipsToBounds = true
        aiModeButton.isExclusiveTouch = true
        aiModeButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        aiModeButton.addTarget(self, action: #selector(twoPlayerMode), for: .touchUpInside)
        aiModeButton.addTarget(self, action: #selector(selectButton), for: .touchDown)
        aiModeButton.addTarget(self, action: #selector(deselectButton), for: .touchDragOutside)
        
        twoPlayerModeButton.alpha = 0.0
        aiModeButton.isEnabled = false
        twoPlayerModeButton.setTitle("Play vs. AI", for: .normal)
        twoPlayerModeButton.setTitleColor(.white, for: .normal)
        twoPlayerModeButton.backgroundColor = UIColor(red: 0.96, green: 0.38, blue: 0.38, alpha: 1.0)
        twoPlayerModeButton.layer.cornerRadius = 14
        twoPlayerModeButton.clipsToBounds = true
        twoPlayerModeButton.isExclusiveTouch = true
        twoPlayerModeButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        twoPlayerModeButton.addTarget(self, action: #selector(aiMode), for: .touchUpInside)
        twoPlayerModeButton.addTarget(self, action: #selector(selectButton), for: .touchDown)
        twoPlayerModeButton.addTarget(self, action: #selector(deselectButton), for: .touchDragOutside)
    }
    
    // Animate button selection
    @objc func selectButton(sender: UIButton) {
        audioPlayer.playSoundSelectColumn()
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.1,
            delay: 0.0,
            options: [ .curveEaseInOut ],
            animations: {
                sender.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        })
    }
    
    // Animate button deselection
    @objc func deselectButton(sender: UIButton) {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.1,
            delay: 0.0,
            options: [ .curveEaseInOut ],
            animations: {
                sender.transform = .identity
        })
    }
    
    // Add buttons to view
    func addButtons() {
        self.addSubview(aiModeButton)
        self.addSubview(twoPlayerModeButton)
    }
    
    // Button: start AI game mode
    @objc func aiMode() {
        UIView.transition(from: self, to: GameView(ai: true), duration: 0.3, options: [ .transitionCrossDissolve ])
    }
    
    // Button: start two-player game mode
    @objc func twoPlayerMode() {
        UIView.transition(from: self, to: GameView(ai: false), duration: 0.3, options: [ .transitionCrossDissolve ])
    }
    
    // Animate the title
    func runView() {
        animateTitleLabel.startAnimation(afterDelay: 1.0)
    }
    
    // Set up the view's elements
    func setUpView() {
        self.backgroundColor = UIColor(patternImage: UIImage(named: "ViewBackground.png")!)
        addTitleLabel()
        addButtons()
    }
    
    
    // Initialize title animator
    func initTitleAnimator() {
        animateTitleLabel = UIViewPropertyAnimator(duration: 0.8, dampingRatio: 0.5) {
            self.titleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.titleLabel.alpha = 1.0
            self.blueCircle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.blueCircle.alpha = 1.0
            self.redCircle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.redCircle.alpha = 1.0
        }
        animateTitleLabel.addCompletion { (UIViewAnimatingPosition) in
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 1.5,
                delay: 1.0,
                options: [ .curveEaseInOut ],
                animations: {
                    self.titleLabel.frame = self.titleLabel.frame.offsetBy(dx: 0.0, dy: -80.0)
                    self.blueCircle.frame = self.blueCircle.frame.offsetBy(dx: 0.0, dy: -80.0)
                    self.redCircle.frame = self.redCircle.frame.offsetBy(dx: 0.0, dy: -80.0)
                    
                    self.aiModeButton.frame = self.aiModeButton.frame.offsetBy(dx: 0.0, dy: -50.0)
                    self.twoPlayerModeButton.frame = self.twoPlayerModeButton.frame.offsetBy(dx: 0.0, dy: -50.0)
                    self.aiModeButton.alpha = 1.0
                    self.twoPlayerModeButton.alpha = 1.0
            }).addCompletion({ _ in
                self.aiModeButton.isEnabled = true
                self.twoPlayerModeButton.isEnabled = true
            })
        }
    }

}
