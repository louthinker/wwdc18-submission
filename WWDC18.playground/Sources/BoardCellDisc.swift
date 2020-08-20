
/* Class: BoardCellDisc */
/* Main element of the game. */

import UIKit

public class BoardCellDisc {
    
    var color: BoardCellDiscColor
    var image: UIImage!
    var imageView: UIImageView
    var win: Bool
    let discWidth: CGFloat = 60.0
    let discHeight: CGFloat = 60.0
    
    init() {
        self.color = .none
        image = UIImage(named: "Discs/NoneDisc.png")
        imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: discWidth, height: discHeight))
        imageView.alpha = 0.0
        imageView.image = image
        win = false
    }
    
    convenience init(color: BoardCellDiscColor) {
        self.init()
        self.color = color
        switch color {
            case .blue:
                image = UIImage(named: "Discs/BlueDisc.png")
                break
            case .red:
                image = UIImage(named: "Discs/RedDisc.png")
                break
            default:
                image = UIImage(named: "Discs/NoneDisc.png")
                break
        }
        imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: discWidth, height: discHeight))
        imageView.alpha = 1.0
        imageView.image = image
    }
    
    // Switch the disc's color
    func switchColor(color: BoardCellDiscColor) {
        self.color = color
        switch color {
            case .blue:
                image = UIImage(named: "Discs/BlueDisc.png")
                break
            case .red:
                image = UIImage(named: "Discs/RedDisc.png")
                break
            default:
                image = UIImage(named: "Discs/NoneDisc.png")
                break
        }
        imageView.image = image
    }
    
    // Animate the color switch
    func switchColorAnimated(color: BoardCellDiscColor) {
        self.color = color
        switch color {
            case .blue:
                image = UIImage(named: "Discs/BlueDisc.png")
                break
            case .red:
                image = UIImage(named: "Discs/RedDisc.png")
                break
            default:
                image = UIImage(named: "Discs/NoneDisc.png")
                break
        }
        UIView.transition(with: imageView, duration: 0.14, options: .transitionCrossDissolve, animations: {
            self.imageView.image = self.image
        }, completion: nil)
    }
    
    // Preview a color switch
    func previewColorSwitch(color: BoardCellDiscColor) {
        let previewImage: UIImage!
        switch color {
            case .blue:
                previewImage = UIImage(named: "Discs/BlueDisc-Light.png")
                break
            case .red:
                previewImage = UIImage(named: "Discs/RedDisc-Light.png")
                break
            default:
                previewImage = UIImage(named: "Discs/NoneDisc.png")
                break
        }
        UIView.transition(with: imageView, duration: 0.14, options: .transitionCrossDissolve, animations: {
            self.imageView.image = previewImage
        }, completion: nil)
    }
    
}

