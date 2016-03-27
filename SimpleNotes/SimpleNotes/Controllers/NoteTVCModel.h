
#import <Foundation/Foundation.h>

@class Note, NoteTVC;

@interface NoteTVCModel : NSObject
@property (nonatomic) NSDateFormatter *dateFormatter;

- (void)configireNoteCell:(NoteTVC *)cell forNote:(Note *)note;

@end
