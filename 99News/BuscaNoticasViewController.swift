//
//  BuscaNoticasViewController.swift
//  99News
//
//  Created by Usuário Convidado on 09/12/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit
import CoreData


class BuscaNoticasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var fetchedResultController: NSFetchedResultsController?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var managedObjectContext: NSManagedObjectContext?
        
        managedObjectContext = Setup.getManagedObjectContext()
        
        let noticiaDao: NoticiaDAO = NoticiaDAO(managedObjectContext: managedObjectContext!)
        
        self.fetchedResultController = noticiaDao.getFetchedResultsController()
        
        fetchedResultController!.delegate = self
        
        do{
            try self.fetchedResultController?.performFetch()
            
        }catch{
            print("erro")
        }
  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let cont = self.fetchedResultController!.fetchedObjects?.count{
            return cont
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellArtigoSalvo", forIndexPath: indexPath)
        let noticia: Noticia = self.fetchedResultController?.objectAtIndexPath(indexPath) as! Noticia
        cell.textLabel!.text = noticia.titulo
        cell.detailTextLabel!.text = noticia.conteudo
        return cell
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
