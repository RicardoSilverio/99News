//
//  BuscaTableViewController.swift
//  99News
//
//  Created by Usuário Convidado on 25/11/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit
import CoreData
import Haneke

class BuscaTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, NYTimesServiceDelegate, ExtractServiceDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var campoBusca: UISearchBar!
    
    @IBOutlet weak var btnSalvarTema: UIButton!
    
    
    @IBOutlet weak var tableView: UITableView!
    var noticias: [NoticiaVO] = []
    
    var requisicao: NYTimesService?
    
    var busca: String?
    
    var extractService:ExtractService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extractService = ExtractService()
        extractService!.delegate = self
        
        let info = NSUserDefaults.standardUserDefaults().objectForKey("infoExibida")
        if(info == nil) {
            alerta("Toque e segure sobre uma notícia para salvá-la", titulo: "Dica", botao: "Ok")
            NSUserDefaults.standardUserDefaults().setValue("S", forKey: "infoExibida")
        }
            
        
        if(busca != nil){
            requisicao = NYTimesService(query: busca!)
            requisicao!.delegate = self
            requisicao!.executarPesquisa()
        }
    
    }
    
    func pesquisaCompletada(resultados: [NoticiaVO]) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.noticias.appendContentsOf(resultados)
            self.tableView.reloadData()
        }
    }
    
    func extracaoArtigoCompletada(noticiaComConteudoExtraido: NoticiaVO) {
        let managedObjectContext:NSManagedObjectContext = Setup.getManagedObjectContext()
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
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let cell =  self.tableView.cellForRowAtIndexPath((noticiaEnviada.celula)!)
            cell?.backgroundColor = UIColor.clearColor()
            self.alerta("Não foi possível salvar a notícia. Tente novamente mais tarde.", titulo: "Erro", botao: "Ok")
        }
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let temaDao: TemaDAO = TemaDAO(managedObjectContext: Setup.getManagedObjectContext())
        if(temaDao.isTemaSalvo(searchText)){
            btnSalvarTema.setImage(UIImage(named: "full_star"), forState: .Normal)
        } else {
            btnSalvarTema.setImage(UIImage(named: "empty_star"), forState: .Normal)
        }
    }
    
    @IBAction func adicionarTema(sender: UIButton) {
        campoBusca.resignFirstResponder()
        let managedObjectContext: NSManagedObjectContext = Setup.getManagedObjectContext()
        if(campoBusca.text! != ""){
            let temaDao: TemaDAO = TemaDAO(managedObjectContext: managedObjectContext)
            
            if(temaDao.isTemaSalvo(campoBusca.text!)){
                alerta("Tema já está salvo", titulo: "Atenção", botao: "Ok")
            }
            else{
                do{
                    let newTema:Tema = Tema.getNewTema(managedObjectContext)
                    newTema.nome = campoBusca.text!
                    try managedObjectContext.save()
                    btnSalvarTema.setImage(UIImage(named: "full_star"), forState: .Normal)
                    
                }catch{
                    managedObjectContext.rollback()
                    alerta("Não foi possível salvar", titulo: "Erro", botao: "Ok")
                }

                alerta("Tema salvo com sucesso!", titulo: "99News", botao: "Ok")
            }
        }
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        requisicao = NYTimesService(query: searchBar.text!)
        requisicao!.delegate = self
        requisicao!.executarPesquisa()
        
    }
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
        if(campoBusca != nil && campoBusca.text != nil && campoBusca.text != ""){
            let temaDao: TemaDAO = TemaDAO(managedObjectContext: Setup.getManagedObjectContext())
            if(temaDao.isTemaSalvo(campoBusca.text!)) {
                btnSalvarTema.setImage(UIImage(named: "full_star"), forState: .Normal)
            } else {
                btnSalvarTema.setImage(UIImage(named: "empty_star"), forState: .Normal)

            }
        }
    }
    func salvaNoticia(gesture: MyLongPress){
        if(gesture.state == .Began){
            if(Reachability.isConnectedToNetwork()){
                let managedObjectContext:NSManagedObjectContext = Setup.getManagedObjectContext()
                let noticiaDao: NoticiaDAO = NoticiaDAO(managedObjectContext: managedObjectContext)
                if(!noticiaDao.isNoticiaSalva((gesture.noticia?.url)!)){
                    extractService?.extrairArtigo((gesture.noticia)!)
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        let cell =  self.tableView.cellForRowAtIndexPath((gesture.noticia!.celula)!)
                        cell?.backgroundColor = UIColor.redColor()
                    }
                }
                else{
                    alerta("Noticia já está salva", titulo: "Erro", botao: "Ok")
                }
            }
            else{
                alerta("Não há conexão com a Internet. Tente novamente mais tarde!", titulo: "Atenção", botao: "Ok")
            }
        }
        //gesture.noticia
    }
    
    
    func alerta(mensagem: String, titulo: String, botao: String){
        let alert = UIAlertController(title: titulo, message: mensagem, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: botao, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return noticias.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("buscaToWebSegue", sender: indexPath)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.campoBusca?.resignFirstResponder()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(scrollView.contentOffset.y)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let noticiaVO = self.noticias[(sender as! NSIndexPath).row]
        let noticiaDAO = NoticiaDAO(managedObjectContext: Setup.getManagedObjectContext())
        if let noticiaSalva = noticiaDAO.consultarNoticiaPorURL(noticiaVO.url) {
            noticiaVO.conteudo = noticiaSalva.conteudo
        }
        let destinationViewController = segue.destinationViewController as! WebViewController
        destinationViewController.noticia = noticiaVO
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:NoticiaTableViewCell = (tableView.dequeueReusableCellWithIdentifier("CellArtigo", forIndexPath: indexPath) as! NoticiaTableViewCell)
        let noticia: NoticiaVO = noticias[indexPath.row]
        let longPress = MyLongPress(target: self, action: "salvaNoticia:")
        longPress.minimumPressDuration = 0.5
        noticia.celula = indexPath
        longPress.noticia = noticia
        cell.addGestureRecognizer(longPress)
        ///

            cell.txtTitulo.text = noticia.titulo
            cell.txtResumo.text = noticia.resumo
            cell.txtTitulo.backgroundColor = UIColor.clearColor()
            cell.txtResumo.backgroundColor = UIColor.clearColor()
        
        
            /*
            cell.imageView?.frame = CGRectMake(0, 0, 60, 40)
            cell.imageView?.contentMode = .ScaleToFill
            cell.imageView?.image = UIImage(named: "save")
            DownloadImagem.downloadImage(noticia.imagemURL!, celula: cell)
            */
        
    
        let noticiaDao: NoticiaDAO = NoticiaDAO(managedObjectContext: Setup.getManagedObjectContext())
        if(noticiaDao.isNoticiaSalva(noticia.url)){
            cell.backgroundColor = UIColor.redColor()
        }
        else{
            cell.backgroundColor = UIColor.clearColor()
        }
        
        cell.imgFoto.image = UIImage(named: "newspaper")
        if(noticia.imagemURL != nil){
            cell.imgFoto.contentMode = .ScaleToFill
            DownloadImagem.downloadImage(noticia.imagemURL!, celula: cell)
        }
        
        return cell
    }
    
}
