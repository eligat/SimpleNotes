
#import "DataManager.h"
#import <Photos/Photos.h>
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
+ (NSArray<Note *> *)allNotes {
    NSArray *notes = [Note MR_findAllSortedBy:@"created" ascending:NO];
    return notes;
}

+ (Note *)newTemporaryNoteWithNote:(Note *)note {
    Note *tmpNote = [Note MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
    tmpNote.name = note.name;
    tmpNote.text = note.text;
    tmpNote.images = note.images;
    
    return tmpNote;
}

+ (Image *)newImageWithAsset:(PHAsset *)asset{
    if (!asset) return nil;
    
    Image *img = [Image MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
    img.fileRef = asset.localIdentifier;
    
    return img;
}

+ (void)deleteAllNotes {
    NSArray *notes = [Note MR_findAll];
    for (Note *note in notes) {
        for (Image *img in note.images) {
            [note removeImagesObject:img];
            [img MR_deleteEntity];
        }
        
        [note MR_deleteEntity];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}


+ (void)fetchThumbnailImagesForNote:(Note *)note ofTargerSize:(CGSize)targetSize completion:(void(^)(NSArray<UIImage *> *images))completion {
    NSMutableArray *resultImages = [NSMutableArray new];
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.synchronous = YES;
    
    dispatch_queue_t fetchQueue = dispatch_queue_create("fetchImagesQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_group_t fetchGroup = dispatch_group_create();
    
    for (Image *img in note.images) {
        
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[img.fileRef] options:nil];
        PHAsset *asset = fetchResult.firstObject;
        
        dispatch_group_enter(fetchGroup);
        dispatch_async(fetchQueue, ^{
            [imageManager requestImageForAsset:asset
                                    targetSize:targetSize
                                   contentMode:PHImageContentModeAspectFill
                                       options:options
                                 resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                     
                                     if (result) {
                                         [resultImages addObject:result];
                                     }
                                     
                                     dispatch_group_leave(fetchGroup);
                                 }];
        });
    }
    
    dispatch_group_notify(fetchGroup, dispatch_get_main_queue(), ^{
        if (completion) {
            completion(resultImages);
        };
    });
}

+ (void)fetchFullSizedImageForImage:(Image *)img completion:(void(^)(UIImage *image))completion {
    PHImageManager *imageManager = [PHImageManager defaultManager];
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.synchronous = YES;
    
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[img.fileRef] options:nil];
    PHAsset *asset = fetchResult.firstObject;

    [imageManager   requestImageForAsset:asset
                            targetSize:PHImageManagerMaximumSize
                           contentMode:PHImageContentModeAspectFill
                               options:options
                         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                             
                             if (completion) {
                                 completion(result);
                             }
                             
                         }];
}

@end
