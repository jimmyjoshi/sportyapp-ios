//
//  UIImageView+DownloadImageURL.swift
//
//
//

import Foundation
import UIKit
extension UIImageView {
    func downloadImage(from:String)
    {
        let strURL : String = from.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        let url2 = URL(string: strURL)
        if url2 != nil {
        getDataFromUrl(url: url2!) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                if data == nil {
                    self.image = UIImage(named: "TimeLinePlaceholder")
                }else {
                    self.image = UIImage(data: data)
                }
                
            }
        }
        }
    }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
}
