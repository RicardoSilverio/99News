//
//  HTMLFileService.swift
//  99News
//
//  Created by Usuário Convidado on 02/12/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit

class HTMLFileService: NSObject {
    
    let pathPaginaHTML:String
    
    override init() {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docPath = path[0]
        pathPaginaHTML = docPath + "/" + "articlePage.html"
        print(pathPaginaHTML)
    }
    
    func escreverArquivo(conteudo:String) {
        let data = conteudo.dataUsingEncoding(NSUTF8StringEncoding)!
        NSFileManager.defaultManager().createFileAtPath(pathPaginaHTML, contents: data, attributes: nil)
    }

}
