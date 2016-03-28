
#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>

@class Note, Image;


@interface DataManager : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)sharedManager;

// Note
- (NSArray<Note *> *)allNotes;
- (Note *)newTemporaryNoteWithNote:(Note *)note;

// Image
- (Image *)newImageWithReferenceURL:(NSURL *)url;
@end
