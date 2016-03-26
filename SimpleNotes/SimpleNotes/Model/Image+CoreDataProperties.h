//
//  Image+CoreDataProperties.h
//  SimpleNotes
//
//  Created by eligat on 3/26/16.
//  Copyright © 2016 Oleg Sannikov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Image.h"

NS_ASSUME_NONNULL_BEGIN

@interface Image (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *fileName;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) Note *note;

@end

NS_ASSUME_NONNULL_END
