
#import "Note.h"

@class Image;

NS_ASSUME_NONNULL_BEGIN

@interface Note (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *created;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSDate *updated;
@property (nullable, nonatomic, retain) NSOrderedSet<Image *> *images;

@end

@interface Note (CoreDataGeneratedAccessors)

- (void)insertObject:(Image *)value inImagesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromImagesAtIndex:(NSUInteger)idx;
- (void)insertImages:(NSArray<Image *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeImagesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInImagesAtIndex:(NSUInteger)idx withObject:(Image *)value;
- (void)replaceImagesAtIndexes:(NSIndexSet *)indexes withImages:(NSArray<Image *> *)values;
- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSOrderedSet<Image *> *)values;
- (void)removeImages:(NSOrderedSet<Image *> *)values;

@end

NS_ASSUME_NONNULL_END
