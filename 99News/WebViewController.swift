//
//  WebViewController.swift
//  99News
//
//  Created by Usuário Convidado on 09/12/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    var noticia:NoticiaVO?
    var htmlService:HTMLFileService!
    @IBOutlet weak var noticiaWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if(Reachability.isConnectedToNetwork()){
            
            let url = NSURL(string: noticia!.url)
            let request = NSURLRequest(URL: url!)
            self.noticiaWebView.loadRequest(request)
        
        }else{
            
            htmlService.escreverArquivo(noticia!.resumo)
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let request = NSURLRequest(URL: self.htmlService!.getURLArquivo())
            self.noticiaWebView.loadRequest(request)
            
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
