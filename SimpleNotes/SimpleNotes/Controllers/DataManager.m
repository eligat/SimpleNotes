
#import "DataManager.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Note+CoreDataProperties.h"

@implementation DataManager

#pragma mark - Lifecycle

+ (instancetype)sharedManager {
    static DataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [DataManager new];
    });
    
    return manager;
}


#pragma mark - Public
- (NSArray<Note *> *)allNotes {
    NSArray *notes = [Note MR_findAllSortedBy:@"created" ascending:YES];
    return notes;
}

@end
