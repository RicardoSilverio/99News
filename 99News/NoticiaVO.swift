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
    var resumo:String
    var imagemURL:String?
    //
    
    init(titulo:String, url:String, resumo:String, imagem:String?) {
        self.titulo = titulo
        self.url = url
        self.resumo = resumo
        self.imagemURL = imagem
    }

}
