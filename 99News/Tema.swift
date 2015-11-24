//
//  Tema.swift
//  99News
//
//  Created by Ricardo Silverio de Souza on 24/11/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import Foundation
import CoreData


class Tema: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    class func getNewTema(managedObjectContext:NSManagedObjectContext) -> Noticia {
        let entityDescription = NSEntityDescription.entityForName("Tema", inManagedObjectContext: managedObjectContext)
        return Noticia(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
    }

}
