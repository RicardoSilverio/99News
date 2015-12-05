//
//  HTMLFileService.swift
//  99News
//
//  Created by Usuário Convidado on 02/12/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit

class HTMLFileService: NSObject {
    
    private let pathPaginaHTML:String
    private let urlArquivo:NSURL
    
    override init() {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docPath = path[0]
        pathPaginaHTML = docPath + "/" + "articlePage.html"
        urlArquivo = NSURL(fileURLWithPath: self.pathPaginaHTML)
    }
    
    func escreverArquivo(conteudo:String) {
        let data = conteudo.dataUsingEncoding(NSUTF8StringEncoding)!
        NSFileManager.defaultManager().createFileAtPath(pathPaginaHTML, contents: data, attributes: nil)
    }
    
    func getURLArquivo() -> NSURL {
        return urlArquivo
    }
    
    /* Exemplo de uso em webview

        htmlService?.escreverArquivo(noticia.resumo)
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
        let request = NSURLRequest(URL: self.htmlService!.getURLArquivo())
        self.webView.loadRequest(request)
    */

}
