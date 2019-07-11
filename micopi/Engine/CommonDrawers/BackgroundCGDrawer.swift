import CoreGraphics

struct BackgroundCGDrawer {
    
    let context: CGContext
    let imageSize: CGFloat
    
    func fillWithColor(_ color: CGColor) {
        let fullRect = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
        context.setFillColor(color)
        context.fill(fullRect)
    }
}
