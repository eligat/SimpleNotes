//
//  Note+CoreDataProperties.m
//  SimpleNotes
//
//  Created by eligat on 3/26/16.
//  Copyright © 2016 Oleg Sannikov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Note+CoreDataProperties.h"

@implementation Note (CoreDataProperties)

@dynamic name;
@dynamic text;
@dynamic created;
@dynamic updated;
@dynamic images;

@end
