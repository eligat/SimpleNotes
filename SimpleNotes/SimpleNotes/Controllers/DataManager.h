
#import <Foundation/Foundation.h>


@class Note;


@interface DataManager : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)sharedManager;

- (NSArray<Note *> *)allNotes;

@end
