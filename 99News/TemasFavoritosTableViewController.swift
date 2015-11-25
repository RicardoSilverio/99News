import UIKit
import CoreData

class TemasFavoritosTableViewController: UITableViewController {
    
    var managedObjectContext:NSManagedObjectContext?
    var temaDAO:TemaDAO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = Setup.getManagedObjectContext();
        temaDAO = TemaDAO(managedObjectContext: managedObjectContext!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Retorna o numero de sessoes da tableview
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //Retorna o numero de linhas por sessao, para isso o metodo veirifica
    //a quantidade de itens no getFetchedResultsController
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cont = temaDAO?.getFetchedResultsController().fetchedObjects?.count{
            return cont
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath)
        let tema: Tema = temaDAO?.getFetchedResultsController().objectAtIndexPath(indexPath) as! Tema
        cell.textLabel?.text = tema.nome
        return cell
    }
}
