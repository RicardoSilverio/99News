//
//  GoogleNewsService.swift
//  99News
//
//  Created by Ricardo Silverio de Souza on 24/11/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit

protocol GoogleNewsServiceDelegate {
    
    func pesquisaCompletada(resultados:[NoticiaVO])
}

class GoogleNewsService: NSObject {
    
    private static let urlAPI:String = "https://ajax.googleapis.com/ajax/services/search/news?v=1.0"
    private var session:NSURLSession?
    
    var delegate:GoogleNewsServiceDelegate?
    
    private var paginaAtual:Int?
    private var totalPaginas:Int?
    
    var limite:Int
    private var query:String
    private var resultadosNoticia:[NoticiaVO] = []
    
    init(query:String, limiteInicial:Int) {
        self.query = query
        self.limite = limiteInicial
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.session = NSURLSession(configuration: sessionConfig)
    }
    
    func executarPesquisa() {
        
        self.resultadosNoticia.removeAll()
        self.totalPaginas = 0
        self.paginaAtual = 1
        
        let urlRequest = NSURL(string: GoogleNewsService.urlAPI + "&q=" + query)
        let task = self.session?.dataTaskWithURL(urlRequest!, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if(error != nil) {
                print("Erro na requisição do json: Pesquisa Inicial de Notícias")
            } else {
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                    if let responseData = json["responseData"] as? [String:AnyObject] {
                        
                        if let cursor = responseData["cursor"] as? [String:AnyObject] {
                            if let pages = cursor["pages"] as? [[String:AnyObject]] {
                                self.totalPaginas = 15
                            } else {
                                self.totalPaginas = 0
                            }
                        }
                        
                        if let results = responseData["results"] as? [[String:AnyObject]] {
                            if(results.count > 0) {
                                self.processarPagina(results)
                            }
                            if(self.resultadosNoticia.count < self.limite && self.totalPaginas > 1) {
                                self.requisitarProximaPagina()
                            } else {
                                self.delegate?.pesquisaCompletada(self.resultadosNoticia)
                            }
                        }
                        
                    }
                } catch {
                    print("Erro na serialização do json: Pesquisa Inicial de Notícias")
                }
                
                
            }
        })
        task?.resume()

    }
    
    func requisitarProximaPagina() {
        if(self.resultadosNoticia.count < self.limite && self.totalPaginas > paginaAtual) {
            self.paginaAtual = self.paginaAtual! + 1
            let urlRequest = NSURL(string: GoogleNewsService.urlAPI + "&q=" + query + "&start=\(self.resultadosNoticia.count)")
            let task = self.session?.dataTaskWithURL(urlRequest!, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                if(error != nil) {
                    print("Erro na requisição do json: Requisição de Página de Resultados - \(self.paginaAtual!)" )
                } else {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                        if let responseData = json["responseData"] as? [String:AnyObject] {
                            
                            if let cursor = responseData["cursor"] as? [String:AnyObject] {
                                if let results = responseData["results"] as? [[String:AnyObject]] {
                                    if(results.count > 0) {
                                        self.processarPagina(results)
                                    }
                                    if(self.resultadosNoticia.count < self.limite && self.totalPaginas > self.paginaAtual) {
                                        self.requisitarProximaPagina()
                                    } else {
                                        self.delegate?.pesquisaCompletada(self.resultadosNoticia)
                                    }
                                }
                            }
                        }
                    } catch {
                        print("Erro na serialização do json: Requisição de Página de Resultados - \(self.paginaAtual!)")
                    }
                }
            })
            task?.resume()
        } else {
            self.delegate?.pesquisaCompletada(self.resultadosNoticia)
        }
    }
    
    private func processarPagina(results:[[String:AnyObject]]) {
        for item in results {
            var imagemURL: String?
            if let imageDic: [String: AnyObject] = item["image"] as? [String: AnyObject]{
                imagemURL = imageDic["url"] as! String
            }
            let noticia:NoticiaVO = NoticiaVO(titulo: convertSpecialCharacters(item["titleNoFormatting"] as! String), url: item["unescapedUrl"] as! String, resumo: convertSpecialCharacters(item["content"] as! String), imagem: imagemURL)
            resultadosNoticia.append(noticia)
            print(noticia.titulo + " (\(noticia.url) [\(noticia.resumo)]")
        }
    }
    
    func convertSpecialCharacters(string: String) -> String {
        var newString = string
        var char_dictionary = [
            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&quot;": "\"",
            "&apos;": "'",
            "&#39;": "'",
            "&nbsp;": "",
            "<b>": "",
            "</b>": ""
        ];
        for (escaped_char, unescaped_char) in char_dictionary {
            newString = newString.stringByReplacingOccurrencesOfString(escaped_char, withString: unescaped_char, options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        }
        return newString
    }

}
