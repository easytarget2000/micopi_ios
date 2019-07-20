import UIKit.UIImage

class BlurCGDrawer: NSObject {
    var ciContext = CIContext(options: nil)
    var currentFilter = CIFilter(name: "CIGaussianBlur")!
    var cropFilter = CIFilter(name: "CICrop")!
    
    func setup(radius: Double) {
        currentFilter.setValue(radius, forKey: kCIInputRadiusKey)
    }

    func applyBlurEffectToImage(
        _ image: UIImage,
        inContext context: CGContext
    ) {
        let ciInputImage = CIImage(image: image)!
        currentFilter.setValue(ciInputImage, forKey: kCIInputImageKey)
        
        cropFilter.setValue(
            currentFilter.outputImage,
            forKey: kCIInputImageKey
        )
        let cropVector = CIVector(cgRect: ciInputImage.extent)
        cropFilter.setValue(cropVector, forKey: "inputRectangle")
        
        let ciOutputImage = cropFilter.outputImage
        let cgOutputImage = ciContext.createCGImage(
            ciOutputImage!,
            from: ciOutputImage!.extent
        )
        context.draw(cgOutputImage!, in: ciInputImage.extent)
    }
}
