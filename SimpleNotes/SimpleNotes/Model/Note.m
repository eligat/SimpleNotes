
#import "Note.h"

@implementation Note

- (void)awakeFromInsert{
    self.created = [NSDate date];
    self.updated = [NSDate date];
}

// Bug http://stackoverflow.com/q/7385439/4398053
- (void)addImagesObject:(Image *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.images];
    [tempSet addObject:value];
    self.images = tempSet;
}

- (void)removeImages:(NSOrderedSet<Image *> *)values {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.images];
    [tempSet removeObjectsInArray:values.array];
    self.images = tempSet;
}

@end
