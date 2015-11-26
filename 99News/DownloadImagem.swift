//
//  DownloadImagem.swift
//  99News
//
//  Created by Usuário Convidado on 25/11/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit

class DownloadImagem: NSObject {

    class func downloadImage(imgURL: String, celula:UITableViewCell){
        let url = NSURL(string: imgURL)!
        let imageSession = NSURLSession.sharedSession()
        let imgTask = imageSession.downloadTaskWithURL(url) {(url, response, error) -> Void in
            if( error == nil){
                if let imageData = NSData(contentsOfURL: url!){
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        celula.imageView?.image = UIImage(data: imageData)
                    })
                }
            }
            else{
                print("Erro ao baixar imagem")
            }
        }
        imgTask.resume()
        
    }
    
}
