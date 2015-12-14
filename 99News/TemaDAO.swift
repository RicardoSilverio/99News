//
//  TemaService.swift
//  99News
//
//  Created by Ricardo Silverio de Souza on 24/11/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit
import CoreData

class TemaDAO: NSObject {
    
    private let managedObjectContext:NSManagedObjectContext
    
    init(managedObjectContext:NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        let fetchRequest = NSFetchRequest(entityName: "Tema")
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func isTemaSalvo(nome: String) -> Bool {
        
        let fetchRequest = NSFetchRequest(entityName: "Tema")
        
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "ANY nome like[c] '" + nome + "'")
        fetchRequest.predicate = predicate
        
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            if(results.count > 0) {
                return true
            }
        } catch {
            print("Erro ao pesquisar tema no banco")
        }
        return false
    }


}
