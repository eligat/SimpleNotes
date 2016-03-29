
#import "Image.h"
#import "Note.h"

@implementation Image

// Insert code here to add functionality to your managed object subclass

- (void)prepareForDeletion{
    NSLog(@"%s", __func__);
}

- (BOOL)validateForDelete:(NSError * _Nullable __autoreleasing *)error {
    NSLog(@"%s", __func__);
    return YES;
}
@end
