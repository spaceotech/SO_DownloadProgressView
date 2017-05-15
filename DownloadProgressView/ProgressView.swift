
import UIKit

@IBDesignable open class ProgressView: UIView {

    open weak var delegate: ProgressViewDelegate?
    
    @IBInspectable open var value: CGFloat = 0 {
        didSet {
            self.progressLayer.value = self.value
        }
    }

    open var currentValue: CGFloat? {
        get {
            if isAnimating {
                return self.layer.presentation()?.value(forKey: "value") as? CGFloat
            } else {
                return self.value
            }
        }
    }
    @IBInspectable open var maxValue: CGFloat = 100 {
        didSet {
            self.progressLayer.maxValue = self.maxValue
        }
    }
    
    @IBInspectable open var viewStyle: Int = 1 {
        didSet {
            self.progressLayer.viewStyle = self.viewStyle
        }
    }
    open var patternForDashes: [CGFloat] = [7.0, 7.0] {
        didSet {
            self.progressLayer.patternForDashes = self.patternForDashes
        }
    }
    @IBInspectable open var startAngle: CGFloat = 0 {
        didSet {
            self.progressLayer.startAngle = self.startAngle
        }
    }
    @IBInspectable open var endAngle: CGFloat = 360 {
        didSet {
            self.progressLayer.endAngle = self.endAngle
        }
    }
    @IBInspectable open var outerCircleWidth: CGFloat = 10.0 {
        didSet {
            self.progressLayer.outerCircleWidth = self.outerCircleWidth
        }
    }
    @IBInspectable open var outerCircleColor: UIColor = UIColor.gray {
        didSet {
            self.progressLayer.outerCircleColor = self.outerCircleColor
        }
    }
    @IBInspectable open var innerCircleWidth: CGFloat = 5.0 {
        didSet {
            self.progressLayer.innerCircleWidth = self.innerCircleWidth
        }
    }
    @IBInspectable open var innerCircleColor: UIColor = UIColor.blue {
        didSet {
            self.progressLayer.innerCircleColor = self.innerCircleColor
        }
    }
    @IBInspectable open var innerCircleSpacing: CGFloat = 1 {
        didSet {
            self.progressLayer.innerCircleSpacing = self.innerCircleSpacing
        }
    }
    @IBInspectable open var isShowText: Bool = true {
        didSet {
            self.progressLayer.isShowText = self.isShowText
        }
    }
    @IBInspectable open var textColor: UIColor = UIColor.black {
        didSet {
            self.progressLayer.textColor = self.textColor
        }
    }
    @IBInspectable open var font: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            self.progressLayer.font = self.font
        }
    }
    @IBInspectable open var textProgresser: String = "%" {
        didSet {
            self.progressLayer.textProgresser = self.textProgresser
        }
    }
    open var animationStyle: String = kCAMediaTimingFunctionEaseIn {
        didSet {
            self.progressLayer.animationStyle = self.animationStyle
        }
    }
    open var isAnimating: Bool {
        get { return (self.layer.animation(forKey: "value") != nil) ? true : false }
    }
    internal var progressLayer: UIProgressLayer {
        return self.layer as! UIProgressLayer
    }
    
    override open class var layerClass: AnyClass {
        get {
            return UIProgressLayer.self
        }
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
        // Call the internal initializer
        initialize()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Call the internal initializer
        initialize()
    }
    //MARK:- initialization -
    internal func initialize() {
        self.layer.contentsScale = UIScreen.main.scale
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale * 2
        self.progressLayer.value = value
        self.progressLayer.maxValue = maxValue
        self.progressLayer.viewStyle = viewStyle
        self.progressLayer.patternForDashes = patternForDashes
        self.progressLayer.startAngle = startAngle
        self.progressLayer.endAngle = endAngle
        self.progressLayer.outerCircleWidth = outerCircleWidth
        self.progressLayer.outerCircleColor = outerCircleColor
        self.progressLayer.innerCircleWidth = innerCircleWidth
        self.progressLayer.innerCircleColor = innerCircleColor
        self.progressLayer.innerCircleSpacing = innerCircleSpacing
        self.progressLayer.isShowText = isShowText
        self.progressLayer.textProgresser = textProgresser
        self.progressLayer.textColor = textColor
        self.progressLayer.font = font
        
        self.backgroundColor = UIColor.clear
        self.progressLayer.backgroundColor = UIColor.clear.cgColor
    }
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    public typealias ProgressCompletion = (() -> Void)
/**
 Sets the current value for the progress ring, calling this method while Circle is animating will cancel the previously set animation and start a new one.
 */
    open func setProgress(value: CGFloat, animationDuration: TimeInterval, completion: ProgressCompletion? = nil) {
        if isAnimating { self.layer.removeAnimation(forKey: "value") }
        self.progressLayer.animated = animationDuration > 0
        self.progressLayer.animationDuration = animationDuration
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            // closure block
            self.delegate?.finishedProgress(forCircle: self)
            completion?()
        }
        self.value = value
        self.progressLayer.value = value
        CATransaction.commit()
    }
}
