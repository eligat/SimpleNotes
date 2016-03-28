
#import "DataManager.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Note+CoreDataProperties.h"
#import "Image+CoreDataProperties.h"

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

- (Note *)newTemporaryNoteWithNote:(Note *)note {
    Note *tmpNote = [Note MR_createEntity];
    tmpNote.name = note.name;
    tmpNote.text = note.text;
    tmpNote.images = note.images;
    
    return tmpNote;
}

- (Image *)newImageWithReferenceURL:(NSURL *)url{
    Image *img = [Image MR_createEntity];
    img.fileRef = url.absoluteString;
    
    return img;
}

@end
