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
    
    class func getNewTema(managedObjectContext:NSManagedObjectContext) -> Tema {
        let entityDescription = NSEntityDescription.entityForName("Tema", inManagedObjectContext: managedObjectContext)
        return Tema(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
    }

}
