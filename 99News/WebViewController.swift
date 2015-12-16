//
//  WebViewController.swift
//  99News
//
//  Created by Usuário Convidado on 09/12/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate, ExtractServiceDelegate {
    
    var noticia:NoticiaVO?
    var htmlService:HTMLFileService?
    var extractService:ExtractService?
    
    @IBOutlet var btnVoltar: UIBarButtonItem!
    @IBOutlet var btnAtualizar: UIBarButtonItem!
    @IBOutlet var btnSalvarNoticia: UIButton!

    
    @IBOutlet weak var txtTituloOnline: UILabel!
    @IBOutlet weak var txtTitulo: UILabel!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    
    
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var noticiaWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        htmlService = HTMLFileService()
        extractService = ExtractService()
        extractService!.delegate = self
        noticiaWebView.delegate = self
        
        if(Reachability.isConnectedToNetwork()){
            
            txtTitulo.hidden = true
            txtTituloOnline.text = noticia?.titulo
            let managedObjectContext = Setup.getManagedObjectContext()
            let noticiaDAO = NoticiaDAO(managedObjectContext: managedObjectContext)
            
            btnSalvarNoticia.setImage(noticiaDAO.isNoticiaSalva(noticia!.url) ? UIImage(named: "full_bookmark") : UIImage(named: "empty_bookmark"), forState: .Normal)
            
            let url = NSURL(string: noticia!.url)
            let request = NSURLRequest(URL: url!)
            self.noticiaWebView.loadRequest(request)
        
        } else {
            
            if(noticia?.conteudo != nil) {
                
                self.toolbar.items?.removeAll()
                
                txtTituloOnline.hidden = true
                txtTitulo.text = noticia!.titulo
                htmlService!.escreverArquivo(noticia!.conteudo!)
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    let request = NSURLRequest(URL: self.htmlService!.getURLArquivo())
                    self.noticiaWebView.loadRequest(request)
                }
            } else {
                alerta("Conexão com a Internet indisponível. Tente novamente mais tarde", titulo: "Atenção", botao: "Ok")
                progress.hidden = true
            }
        }
        
    }
    
    @IBAction func salvarNoticia(sender: UIButton) {
        
        if(Reachability.isConnectedToNetwork()) {
        
            let managedObjectContext = Setup.getManagedObjectContext()
            let noticiaDAO = NoticiaDAO(managedObjectContext: managedObjectContext)
        
            if(noticiaDAO.isNoticiaSalva(self.noticia!.url)) {
                alerta("Notícia já está salva", titulo: "Atenção", botao: "Ok")
            } else {
                extractService?.extrairArtigo(self.noticia!)
                self.btnSalvarNoticia.setImage(UIImage(named: "full_bookmark"), forState: .Normal)
            }
            
        } else {
             alerta("Conexão com a Internet indisponível. Tente novamente mais tarde", titulo: "Atenção", botao: "Ok")
        }
    }
    
    func extracaoArtigoCompletada(noticiaComConteudoExtraido: NoticiaVO) {
        let managedObjectContext = Setup.getManagedObjectContext()
        do{
            let newNoticia:Noticia = Noticia.getNewNoticia((managedObjectContext))
            
            newNoticia.titulo = noticiaComConteudoExtraido.titulo
            newNoticia.url = noticiaComConteudoExtraido.url
            newNoticia.resumo = noticiaComConteudoExtraido.resumo
            newNoticia.conteudo = noticiaComConteudoExtraido.conteudo
            
            try managedObjectContext.save()
            
        }catch{
            managedObjectContext.rollback()
            alerta("Não foi possível salvar a notícia. Tente novamente mais tarde.", titulo: "Erro", botao: "Ok")
        }
    }
    
    func extracaoArtigoFalhou(noticiaEnviada: NoticiaVO) {
        self.btnSalvarNoticia.setImage(UIImage(named: "empty_bookmark"), forState: .Normal)
        alerta("Não foi possível salvar a notícia. Tente novamente mais tarde.", titulo: "Erro", botao: "Ok")
    }

    
    
    func alerta(mensagem: String, titulo: String, botao: String){
        let alert = UIAlertController(title: titulo, message: mensagem, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: botao, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        let managedObjectContext = Setup.getManagedObjectContext()
        let noticiaDAO = NoticiaDAO(managedObjectContext: managedObjectContext)
        
        btnSalvarNoticia.setImage(noticiaDAO.isNoticiaSalva(noticia!.url) ? UIImage(named: "full_bookmark") : UIImage(named: "empty_bookmark"), forState: .Normal)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        self.progress.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.progress.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func extrairURL(url:String) -> String {
        let stringlength = url.characters.count
        do {
            let regex:NSRegularExpression = try NSRegularExpression(pattern: "^.*/", options: NSRegularExpressionOptions.CaseInsensitive)
            return regex.stringByReplacingMatchesInString(url, options: NSMatchingOptions.WithoutAnchoringBounds, range: NSRange(location: 0, length: stringlength), withTemplate: "")
        } catch {
            print("Erro na construção do regex")
            return ""
        }
    }

}
