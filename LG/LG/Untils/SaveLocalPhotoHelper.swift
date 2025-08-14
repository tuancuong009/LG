//
//  SaveLocalPhotoHlper.swift
//  Gauss AI
//
//  Created by Trung Ng on 3/3/25.
//

import UIKit

class SaveLocalPhotoHelper{
    static let shared = SaveLocalPhotoHelper()
    func saveImageToDocuments(image: UIImage, fileName: String) -> URL? {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        
        // Lấy đường dẫn thư mục Documents
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        if let documentsURL = urls.first {
            let fileURL = documentsURL.appendingPathComponent(fileName)
            
            do {
                try data.write(to: fileURL)
                print("✅ Save success: \(fileURL)")
                return fileURL
            } catch {
                print("❌ Error Saved: \(error)")
            }
        }
        return nil
    }
    
    func loadImageFromDocuments(fileName: String) -> UIImage? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        if let documentsURL = urls.first {
            let fileURL = documentsURL.appendingPathComponent(fileName)
            
            if let imageData = try? Data(contentsOf: fileURL) {
                return UIImage(data: imageData)
            }
        }
        return nil
    }
    
    func saveFileDocumentToLocal(selectedFileURL: URL)-> URL?{
        do {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let destinationURL = documentsDirectory.appendingPathComponent(selectedFileURL.lastPathComponent)
            
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            
            // 📌 Sao chép tệp vào thư mục Documents
            try FileManager.default.copyItem(at: selectedFileURL, to: destinationURL)
            print("✅ Save file: \(destinationURL.path)")
            return destinationURL
            
            
        } catch {
            
            print("❌ Fail save file: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    func urlFileImages(fileName: String) -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        if let documentsURL = urls.first {
            let fileURL = documentsURL.appendingPathComponent(fileName)
            
            return fileURL
        }
        return nil
    }
    
    func loadImageFromURL(fileURL: URL) -> UIImage? {
        if let imageData = try? Data(contentsOf: fileURL) {
            return UIImage(data: imageData)
        }
        return nil
    }
}
