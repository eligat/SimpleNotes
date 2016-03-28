
#import "Note.h"

@implementation Note

- (void)awakeFromInsert{
    self.created = [NSDate date];
    self.updated = self.created;
}

@end
