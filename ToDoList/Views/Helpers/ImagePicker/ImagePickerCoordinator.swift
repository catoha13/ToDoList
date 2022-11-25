import SwiftUI

class ImagePickerCordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @Binding var isShown: Bool
    @Binding var image: UIImage?
    @Binding var url: String?
    
    init(isShown: Binding<Bool>, image: Binding<UIImage?>,url: Binding<String?> ) {
        _isShown = isShown
        _image = image
        _url = url
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imageurl = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
            let nsString: String = imageurl.absoluteString!
            let cut = nsString.components(separatedBy: "/")
            url = cut.last
            image = uiImage
            isShown = false
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}
