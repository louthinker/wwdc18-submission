
/* Class: MyLabel */
/* Create text labels with the same style. */

import UIKit
import PlaygroundSupport
import XCPlayground

public class MyLabel : UILabel {
    
    public init(x: Int, y: Int, w: Int, h: Int, size: Int, text: String) {
        super.init(frame:  CGRect(x: x, y: y, width: w, height: h))
        self.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(size))
        self.text = text
        textAlignment = .center
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

}
