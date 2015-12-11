import UIKit
import CoreData

class TemasFavoritosTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext:NSManagedObjectContext?
    var fetchedResultController: NSFetchedResultsController?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = Setup.getManagedObjectContext();
        let temaDao: TemaDAO = TemaDAO(managedObjectContext: managedObjectContext!)
        
        self.fetchedResultController = temaDao.getFetchedResultsController()
        
        fetchedResultController!.delegate = self
        
        do{
            try self.fetchedResultController?.performFetch()
            
        }catch{
            print("erro")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Retorna o numero de sessoes da tableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //Retorna o numero de linhas por sessao, para isso o metodo veirifica
    //a quantidade de itens no getFetchedResultsController
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cont = self.fetchedResultController!.fetchedObjects?.count{
            return cont
        }
        return 0
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete) {
            let tema = self.fetchedResultController?.objectAtIndexPath(indexPath) as! Tema
            Setup.getManagedObjectContext().deleteObject(tema)
            do {
                try Setup.getManagedObjectContext().save()
                try self.fetchedResultController?.performFetch()
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            } catch {
                print("Falha ao remover tema")
            }
        }
    }
    
    //Carrega a tabela com os valores armazenados no bd
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellTema", forIndexPath: indexPath)
        let tema: Tema = self.fetchedResultController!.objectAtIndexPath(indexPath) as! Tema
        cell.textLabel?.text = tema.nome
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tema: Tema = self.fetchedResultController!.objectAtIndexPath(indexPath) as! Tema
        self.performSegueWithIdentifier("temaToNoticiaSegue", sender: tema.nome)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "temaToNoticiaSegue"){
            let nome: String = sender as! String
            let vc:BuscaTableViewController = segue.destinationViewController as! BuscaTableViewController
            vc.busca = nome
        }
    }
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
}
