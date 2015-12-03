//
//  TestHTMLViewController.swift
//  99News
//
//  Created by Usuário Convidado on 02/12/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit

class TestHTMLViewController: UIViewController, GoogleNewsServiceDelegate, ExtractServiceDelegate {
    
    var newsService:GoogleNewsService?
    var extractService:ExtractService?
    var htmlService:HTMLFileService?
    
    @IBOutlet weak var webView: UIWebView!
    
    

    func pesquisaCompletada(resultados: [NoticiaVO]) {
        let noticia:NoticiaVO = resultados[0]
        extractService!.extrairArtigo(noticia.url)
    }
    
    func requisicaoCompletada(noticia: NoticiaVO) {
        htmlService?.escreverArquivo(noticia.resumo)
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let url = NSURL(fileURLWithPath: self.htmlService!.pathPaginaHTML)
            let request = NSURLRequest(URL: url)
            self.webView.loadRequest(request)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        newsService = GoogleNewsService(query: "Brasil")
        newsService!.delegate = self
        
        extractService = ExtractService()
        extractService!.delegate = self
        
        htmlService = HTMLFileService()
        
        newsService!.executarPesquisa()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
