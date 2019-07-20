import UIKit.UIImage

class BlurCGDrawer: NSObject {
    var ciContext = CIContext(options: nil)
    
    func applyBlurEffectToImage(_ image: UIImage, inContext: context) {
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: image)!
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(3   , forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage.extent), forKey: "inputRectangle")
        
        let output = cropFilter!.outputImage
        let cgimg = ciContext.createCGImage(output!, from: output!.extent)
        //        let processedImage = UIImage(cgImage: cgimg)
        context.draw(cgimg!, in: beginImage.extent)
    }
}
