//
//  GoogleNewsService.swift
//  99News
//
//  Created by Ricardo Silverio de Souza on 24/11/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit

class GoogleNewsService: NSObject {
    
    static let urlAPI:String = "https://ajax.googleapis.com/ajax/services/search/news?v=1.0"
    
    var limitePorPagina:Int
    var query:String
    var resultadosNoticia:[NoticiaVO] = []
    
    init(query:String, limitePorPagina:Int) {
        self.query = query
        self.limitePorPagina = limitePorPagina
    }
    
    func executarPesquisa() -> [NoticiaVO] {
        return resultadosNoticia
    }

}
