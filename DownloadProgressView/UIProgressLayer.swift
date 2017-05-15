
import UIKit


/**
 A private extension to CGFloat in order to provide simple
 conversion from degrees to radians, used when drawing the rings.
 */
private extension CGFloat {
    var toRads: CGFloat { return self * CGFloat(M_PI) / 180 }
}

private extension UILabel {
    func update(withValue value: CGFloat, valueIndicator: String, showsDecimal: Bool, decimalPlaces: Int) {
        if showsDecimal {
            self.text = String(format: "%.\(decimalPlaces)f", value) + "\(valueIndicator)"
        } else {
            self.text = "\(Int(value))\(valueIndicator)"
        }
        self.sizeToFit()
    }
}

class UIProgressLayer: CAShapeLayer {

    @NSManaged var value: CGFloat
    @NSManaged var maxValue: CGFloat
    
    @NSManaged var viewStyle: Int
    @NSManaged var patternForDashes: [CGFloat]
    
    @NSManaged var startAngle: CGFloat
    @NSManaged var endAngle: CGFloat
    
    @NSManaged var outerCircleWidth: CGFloat
    @NSManaged var outerCircleColor: UIColor
    
    @NSManaged var innerCircleWidth: CGFloat
    @NSManaged var innerCircleColor: UIColor

    @NSManaged var innerCircleSpacing: CGFloat
    
    @NSManaged var isShowText: Bool
    @NSManaged var textColor: UIColor
    @NSManaged var font: UIFont
    @NSManaged var textProgresser: String
    
    var animationDuration: TimeInterval = 1.0
    var animationStyle: String = kCAMediaTimingFunctionEaseInEaseOut
    var animated = false
    
     lazy private var valueLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        UIGraphicsPushContext(ctx)
        // Draw the Circle
        drawOuterCircle()
        drawInnerCircle()
        // Draw the text label
        drawTextLabel()
        UIGraphicsPopContext()
    }
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "value" {
            return true
        }
        
        return super.needsDisplay(forKey: key)
    }
    override func action(forKey event: String) -> CAAction? {
        if event == "value" && self.animated {
            let animation = CABasicAnimation(keyPath: "value")
            animation.fromValue = self.presentation()?.value(forKey: "value")
            animation.timingFunction = CAMediaTimingFunction(name: animationStyle)
            animation.duration = animationDuration
            return animation
        }
        
        return super.action(forKey: event)
    }
    
    /**
     Draws the outer circle for the view.
     Sets path properties according to how the user set properties.
     */
    private func drawOuterCircle() {
        guard outerCircleWidth > 0 else { return }
        
        let width = bounds.width
        let height = bounds.width
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let outerRadius = max(width, height)/2 - outerCircleWidth/2
        
        let outerPath = UIBezierPath(arcCenter: center,
                                     radius: outerRadius,
                                     startAngle: startAngle.toRads,
                                     endAngle: endAngle.toRads,
                                     clockwise: true)
        
        outerPath.lineWidth = outerCircleWidth
        outerPath.lineCapStyle = .round
        
        outerCircleColor.setStroke()
        outerPath.stroke()
    }
    
    /**
     Draws the inner circle for the view.
     Sets path properties according to how the user set properties.
     */
    private func drawInnerCircle() {
        guard innerCircleWidth > 0 else { return }
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        // Calculate the center difference between the end and start angle
        let angleDiff: CGFloat = endAngle.toRads - startAngle.toRads
        // Calculate how much we should draw depending on the value set
        let arcLenPerValue = angleDiff / CGFloat(maxValue)
        // The inner end angle some basic math is done
        let innerEndAngle = arcLenPerValue * CGFloat(value) + startAngle.toRads
        
        // The radius for style 1 is set below
        // The radius for style 1 is a bit less than the outer, this way it looks like its inside the circle
        var radiusIn = (max(bounds.width - outerCircleWidth*2 - innerCircleSpacing, bounds.height - outerCircleWidth*2 - innerCircleSpacing)/2) - innerCircleWidth/2
        
        // If the style is different, mae the radius equal to the outerRadius
        if viewStyle >= 2 {
            radiusIn = (max(bounds.width, bounds.height)/2) - (outerCircleWidth/2)
        }
        // Start drawing
        let innerPath = UIBezierPath(arcCenter: center,
                                     radius: radiusIn,
                                     startAngle: startAngle.toRads,
                                     endAngle: innerEndAngle,
                                     clockwise: true)
        innerPath.lineWidth = innerCircleWidth
        innerPath.lineCapStyle = .round
        innerCircleColor.setStroke()
        innerPath.stroke()
    }
    /**
     Draws the text label for the view.
     Only drawn if shouldShowValueText = true
     */
    private func drawTextLabel() {
        guard isShowText else { return }
        
        // Draws the text field
        // Some basic label properties are set
        valueLabel.font = self.font
        valueLabel.textAlignment = .center
        valueLabel.textColor = textColor
        
        valueLabel.update(withValue: value, valueIndicator: textProgresser,
                          showsDecimal: false, decimalPlaces: 1)
        
        // Deterime what should be the center for the label
        valueLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        valueLabel.drawText(in: self.bounds)
    }
}
