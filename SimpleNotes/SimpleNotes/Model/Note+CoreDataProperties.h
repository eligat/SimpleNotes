//
//  Note+CoreDataProperties.h
//  SimpleNotes
//
//  Created by eligat on 3/26/16.
//  Copyright © 2016 Oleg Sannikov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Note.h"

NS_ASSUME_NONNULL_BEGIN

@interface Note (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSDate *created;
@property (nullable, nonatomic, retain) NSDate *updated;
@property (nullable, nonatomic, retain) NSManagedObject *images;

@end

NS_ASSUME_NONNULL_END
