import UIKit

typealias PhotoStorageCommunicatorCallback = (String?) -> ()

class PhotoStorageCommunicator: NSObject {
    
    fileprivate var callback: PhotoStorageCommunicatorCallback?
    
    func saveImage(
        _ image: UIImage,
        callback: @escaping PhotoStorageCommunicatorCallback
    ) {
        self.callback = callback
        UIImageWriteToSavedPhotosAlbum(
            image,
            self,
            #selector(image(_:didFinishSavingWithError:contextInfo:)),
            nil
        )
    }
    
    @objc func image(
        _ image: UIImage,
        didFinishSavingWithError error: Error?,
        contextInfo: UnsafeRawPointer
    ) {
        guard error == nil else {
            let errorMessage = error!.localizedDescription
            NSLog("ERROR: PhotoStorageCommunicator: \(errorMessage)")
            callback?(errorMessage)
            callback = nil
            return
        }
        
        callback?(nil)
        callback = nil
    }
}
