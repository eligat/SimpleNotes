
#import "Image.h"

NS_ASSUME_NONNULL_BEGIN

@interface Image (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *fileName;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) Note *note;

@end

NS_ASSUME_NONNULL_END
