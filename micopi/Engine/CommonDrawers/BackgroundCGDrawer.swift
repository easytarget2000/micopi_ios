import CoreGraphics

class BackgroundCGDrawer: NSObject {
    
    weak var context: CGContext!
    var imageSize = CGFloat(0)
    @IBOutlet var colorConverter: ARGBColorCGConverter!
    
    func setup(context: CGContext, imageSize: CGFloat) {
        self.context = context
        self.imageSize = imageSize
    }
    
    func fillWithColor(_ color: ARGBColor) {
        let cgColor = colorConverter.cgColorFromARGBColor(color)
        context.setFillColor(cgColor)
        let fullRect = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
        context.fill(fullRect)
    }
}
