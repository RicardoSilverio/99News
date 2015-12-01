//
//  ExtractService.swift
//  99News
//
//  Created by Ricardo Silverio de Souza on 01/12/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit

protocol ExtractServiceDelegate {
    
    func requisicaoCompletada(noticia:NoticiaVO)
    
}

class ExtractService: NSObject {
    
    private static let urlAPI:String = "https://api.embed.ly/1/extract?key=fe7cf8083c124ae4a4a60e16c213df3d"
    private var session:NSURLSession?
    
    var delegate:ExtractServiceDelegate?
    
    override init() {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.session = NSURLSession(configuration: sessionConfig)
    }
    
    func extrairArtigo(urlNoticia:String) {
        let urlRequest = NSURL(string: ExtractService.urlAPI + "&url=" + urlNoticia)
        let task = self.session?.dataTaskWithURL(urlRequest!, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if(error != nil) {
                print("Erro na requisição do json: API Extract")
                print(error)
                return
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                let originalURL = json["original_url"] as! String
                let title = json["title"] as! String
                var content = json["content"] as? String
                if(content == nil) {
                    content = json["description"] as? String
                    let link = "<br /><a href=\"\(originalURL)\">Veja a matéria completa.</a>"
                    if(content == nil) {
                        content = ""
                    }
                    content = content! + link
                }
                content = self.removerImagens(content!)
                content = self.montarHTML(content!, titulo: title)
                let milliseconds = json["published"] as? Double
                var date:NSDate?
                if(milliseconds != nil) {
                    date = NSDate(timeIntervalSince1970: NSTimeInterval(milliseconds!/1000))
                } else {
                    date = NSDate()
                }
                self.delegate?.requisicaoCompletada(NoticiaVO(titulo: title, url: originalURL, resumo: content!, imagem: nil, dataPublicacao: date))
            } catch {
                print("Erro na serialização do json: API Extract")
            }

            
        })
        task?.resume()
    }
    
    func montarHTML(conteudo:String, titulo:String) -> String {
        return "<!DOCTYPE html><html><head><title>\(titulo)</title><meta charset=\"UTF-8\"></head><body>" + conteudo + "</body></html>"
    }
    
    func removerImagens(conteudo:String) -> String {
        let stringlength = conteudo.characters.count
        do {
            let regex:NSRegularExpression = try NSRegularExpression(pattern: "<img.*?>", options: NSRegularExpressionOptions.CaseInsensitive)
            return regex.stringByReplacingMatchesInString(conteudo, options: NSMatchingOptions.WithoutAnchoringBounds, range: NSRange(location: 0, length: stringlength), withTemplate: "")
        } catch {
            print("Erro na construção do regex")
            return ""
        }
    }

}
