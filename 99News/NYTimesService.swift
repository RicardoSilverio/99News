//
//  NYTimesService.swift
//  99News
//
//  Created by Ricardo Silverio de Souza on 24/11/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit

protocol NYTimesServiceDelegate {
    
    func pesquisaCompletada(resultados:[NoticiaVO])
}

class NYTimesService: NSObject {
    
    private static let urlAPI:String = "http://api.nytimes.com/svc/search/v2/articlesearch.json"
    private static let keyAPI:String = "&api-key=cec18c0680847cc777aeb0be63e99fc5:6:73646062"
    private var pageCount:Int = 0
    private var session:NSURLSession?
    
    var delegate:NYTimesServiceDelegate?
    
    private var query:String
    private var resultadosNoticia:[NoticiaVO] = []
    
    init(query:String) {
        self.query = query
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.session = NSURLSession(configuration: sessionConfig)
    }
    
    func executarPesquisa() {
        
        self.resultadosNoticia.removeAll()
        
        let urlRequest = NSURL(string: NYTimesService.urlAPI + "?q=" + query + "&page=0" + NYTimesService.keyAPI)
        let task = self.session?.dataTaskWithURL(urlRequest!, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if(error != nil) {
                print("Erro na requisição do json: Pesquisa Inicial de Notícias")
            } else {
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                    if let responseData = json["response"] as? [String:AnyObject] {

                        if let results = responseData["docs"] as? [[String:AnyObject]] {
                            if(results.count > 0) {
                                self.processarPagina(results)
                                self.delegate?.pesquisaCompletada(self.resultadosNoticia)
                            }
                            else{
                                // sem registros
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
      self.pageCount = self.pageCount + 1
        
      let urlRequest = NSURL(string: NYTimesService.urlAPI + "&q=" + query + "&page=" + "\(self.pageCount)" + NYTimesService.keyAPI) //"&start=\(self.resultadosNoticia.count)")
      let task = self.session?.dataTaskWithURL(urlRequest!, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
          if(error != nil) {
              print("Erro na requisição do json: Requisição de Página de Resultados - \(self.pageCount)" )
              print(error)
          } else {
              do {
                  let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                  if let responseData = json["response"] as? [String:AnyObject] {
                      
                          if let results = responseData["docs"] as? [[String:AnyObject]] {
                              if(results.count > 0) {
                                  self.processarPagina(results)
                                  self.delegate?.pesquisaCompletada(self.resultadosNoticia)
                              }
                              else{
                                  //sem registros
                              }
                          }
                  }
              } catch {
                  print("Erro na serialização do json: Requisição de Página de Resultados - \(self.pageCount)")
              }
          }
      })
      task?.resume()
    }
    
    private func processarPagina(results:[[String:AnyObject]]) {
        for item in results {

            var imagemURL: String?
            var titulo: String = ""
            var subtitulo: String = ""
            
            if let header: [String: AnyObject] = item["headline"] as? [String: AnyObject]{
                titulo = header["main"] as! String
            }
            if let sub: String = item["snippet"] as? String{
                subtitulo = sub
            }
            
            if let imagens: [[String: AnyObject]] = item["multimedia"] as? [[String: AnyObject]]{
                if imagens.count > 0{
                    if let imagem: String = imagens[0]["url"] as? String{
                        imagemURL = "http://www.nytimes.com/" + imagem
                    }
                }
            }
            let noticia:NoticiaVO = NoticiaVO(titulo: titulo,
                                              url: item["web_url"] as! String,
                                              resumo: subtitulo,
                imagem: imagemURL, dataPublicacao:nil, celula: nil)
            resultadosNoticia.append(noticia)
            print(noticia.titulo + " (\(noticia.url) [\(noticia.resumo)]")
        }
    }
    
    func convertSpecialCharacters(string: String) -> String {
        var newString = string
        let char_dictionary = [
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
