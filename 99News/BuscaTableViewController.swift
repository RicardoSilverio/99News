//
//  BuscaTableViewController.swift
//  99News
//
//  Created by Usuário Convidado on 25/11/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit
import CoreData

class BuscaTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, NYTimesServiceDelegate {

    @IBOutlet weak var campoBusca: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    var noticias: [NoticiaVO] = []
    
    var requisicao: NYTimesService?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func pesquisaCompletada(resultados: [NoticiaVO]) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.noticias = resultados
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        requisicao = NYTimesService(query: searchBar.text!)
        requisicao!.delegate = self
        requisicao!.executarPesquisa()
        
    }
    
    @IBAction func adicionarFavoritos(sender: UIButton) {
        
    }
    
    func salvaNoticia(gesture: MyLongPress){
        if(Reachability.isConnectedToNetwork()){
            var managedObjectContext:NSManagedObjectContext?
        
            managedObjectContext = Setup.getManagedObjectContext()
        
            let newNoticia:Noticia = Noticia.getNewNoticia((managedObjectContext)!)
        
            newNoticia.titulo = gesture.noticia?.titulo
            newNoticia.url = gesture.noticia?.url
            newNoticia.conteudo = gesture.noticia?.resumo
        
            do{
                try managedObjectContext!.save()
                let cell =  tableView.cellForRowAtIndexPath((gesture.noticia?.celula)!)
//                cell?.textLabel?.backgroundColor = UIColor.redColor()
//                cell?.detailTextLabel?.backgroundColor = UIColor.redColor()
                cell?.backgroundColor = UIColor.redColor()
            
            }catch{
                alerta("Não foi possível salvar", titulo: "Erro", botao: "Ok")
            }
        }
        else{
            alerta("Não há conexão com a internet, tentar mais tarde!", titulo: "Atenção", botao: "Ok")
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

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellArtigo", forIndexPath: indexPath)
        let noticia: NoticiaVO = noticias[indexPath.row]
        let longPress = MyLongPress(target: self, action: "salvaNoticia:")
        longPress.minimumPressDuration = 1
        noticia.celula = indexPath
        longPress.noticia = noticia
        cell.addGestureRecognizer(longPress)
        ///
        
        cell.textLabel!.text = noticia.titulo
        cell.detailTextLabel!.text = noticia.resumo
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.detailTextLabel?.backgroundColor = UIColor.clearColor()
        if(noticia.imagemURL != nil){
            cell.imageView?.image = UIImage(named: "save")
            DownloadImagem.downloadImage(noticia.imagemURL!, celula: cell)
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
