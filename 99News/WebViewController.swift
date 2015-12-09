//
//  WebViewController.swift
//  99News
//
//  Created by Usuário Convidado on 09/12/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    var noticiaUrl:String?
    @IBOutlet weak var noticiaWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Carrega o webview com a url da Noticia, caso a mesma não seja nula
        if(nil != noticiaUrl){
            let url = NSURL(string: noticiaUrl!)
            let request = NSURLRequest(URL: url!)
            self.noticiaWebView.loadRequest(request)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
