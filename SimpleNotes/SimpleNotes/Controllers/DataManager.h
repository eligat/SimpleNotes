
#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>
#import <Photos/Photos.h>

@class Note, Image, PHAsset;


@interface DataManager : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)sharedManager;

// Note
+ (NSArray<Note *> *)allNotes;
+ (Note *)newTemporaryNoteWithNote:(Note *)note;
+ (void)deleteAllNotes;

// Image
+ (Image *)newImageWithAsset:(PHAsset *)asset;
+ (void)fetchThumbnailImagesForNote:(Note *)note ofTargerSize:(CGSize)targetSize completion:(void(^)(NSArray<UIImage *> *images))completion;
+ (void)fetchFullSizedImageForImage:(Image *)img completion:(void(^)(UIImage *image))completion;

@end
