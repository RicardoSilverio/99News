//
//  NoticiaVO.swift
//  99News
//
//  Created by Ricardo Silverio de Souza on 24/11/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit

class NoticiaVO: NSObject {
    
    var titulo:String
    var url:String
    var resumo:String?
    var imagemURL:String?
    var dataPublicacao:NSDate?
    var celula:NSIndexPath?
    var conteudo:String?
    
    init(titulo:String, url:String, resumo:String, imagem:String?, dataPublicacao:NSDate?, celula:NSIndexPath?) {
        self.titulo = titulo
        self.url = url
        self.resumo = resumo
        self.imagemURL = imagem
        self.dataPublicacao = dataPublicacao
        self.celula = celula
    }
    
    init(titulo:String, url:String, conteudo:String) {
        self.titulo = titulo
        self.url = url
        self.conteudo = conteudo
    }

}
