
#import <UIKit/UIKit.h>
#import "ImageListView.h"
#import <NYTPhotoViewer/NYTPhotosViewController.h>

@class Note;

@interface SingleNoteVC : UIViewController <ImageListViewDelegate, NYTPhotosViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet ImageListView *imageList;

@property (nonatomic) Note *note;

- (void)setupNavigationBar;
- (void)updateView;

@end

