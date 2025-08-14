import UIKit
import MessageUI
import StoreKit
enum ShareContent {
    case text(String)
    case image(UIImage)
    case textAndImage(text: String, image: UIImage)
    case file(URL)
}

final class ShareManager: NSObject {
    static let shared = ShareManager()
    
    private override init() {}
    func formatLocationInfo(address: String, date: Date, latitude: Double, longitude: Double) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString = dateFormatter.string(from: date)
        let mapsURL = "http://maps.apple.com/?q=&ll=\(latitude),\(longitude)"
        
        let content = """
        📍 Location:
        🏡 Current Address: \(address)
        ⏰ Time: \(dateString)
        🔗 Open in Maps: \(mapsURL)
        """
        return content
    }
    
    // MARK: - General Share Sheet
    func share(_ content: ShareContent, from controller: UIViewController) {
        var activityItems: [Any] = []
        
        switch content {
        case .text(let text):
            activityItems = [text]
        case .image(let image):
            activityItems = [image]
        case .textAndImage(let text, let image):
            activityItems = [text, image]
        case .file(let fileURL):
            activityItems = [fileURL]
        }

        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        controller.present(activityVC, animated: true)
    }
    func requestReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    // MARK: - Share via Specific Apps
    func shareViaWhatsApp(text: String) {
        let urlString = "whatsapp://send?text=\(text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        openURLScheme(urlString)
    }
    
    func shareViaInstagram(image: UIImage, from viewController: UIViewController) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("temp_instagram.igo")
        
        do {
            try imageData.write(to: tempURL)
            let docController = UIDocumentInteractionController(url: tempURL)
            docController.uti = "com.instagram.exclusivegram"
            docController.presentOpenInMenu(from: viewController.view.frame, in: viewController.view, animated: true)
        } catch {
            print("Instagram sharing failed: \(error)")
        }
    }
    
    func shareViaMessenger(text: String) {
        let urlString = "fb-messenger://share/?text=\(text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        print(urlString)
        openURLScheme(urlString)
    }
    func createKMLFile(content: String, fileName: String = "location.kml") -> URL? {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(fileName)
        
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("❌ Failed to write KML file: \(error)")
            return nil
        }
    }
    
    func shareViaMessage(text: String, image: UIImage?, from viewController: UIViewController) {
        guard MFMessageComposeViewController.canSendText() else { return }
        let messageVC = MFMessageComposeViewController()
        messageVC.body = text
        messageVC.messageComposeDelegate = self
        if let image = image{
            if let imageData = image.jpegData(compressionQuality: 0.9) {
                messageVC.addAttachmentData(imageData, typeIdentifier: "public.data", filename: "photo.jpg")
            }
        }
        
        
        viewController.present(messageVC, animated: true)
    }

    func shareViaEmail(subject: String, body: String, image: UIImage?, from viewController: UIViewController) {
        guard MFMailComposeViewController.canSendMail() else { return }
        let mailVC = MFMailComposeViewController()
        mailVC.setSubject(subject)
        mailVC.setMessageBody(body, isHTML: false)
        mailVC.mailComposeDelegate = self
        if let image = image{
            if let imageData = image.jpegData(compressionQuality: 0.9) {
                mailVC.addAttachmentData(imageData, mimeType: "image/jpeg", fileName: "photo.jpg")
            }
        }
        
        viewController.present(mailVC, animated: true)
    }

    func copyToClipboard(text: String) {
        UIPasteboard.general.string = text
    }
    
    // MARK: - Helpers
    private func openURLScheme(_ urlString: String) {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            
        } else {
            print("Fail: \(urlString)")
        }
    }
    
    
    func shareViaEmailSetting(subject: String, body: String, email:String, from viewController: UIViewController) {
        guard MFMailComposeViewController.canSendMail() else { return }
        let mailVC = MFMailComposeViewController()
        mailVC.setSubject(subject)
        mailVC.setMessageBody(body, isHTML: true)
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients([email])
        
        viewController.present(mailVC, animated: true)
    }
}

// MARK: - Delegates
extension ShareManager: MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
