
#import <UIKit/UIKit.h>

@class Note, ImageListView;

@interface SingleNoteVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet ImageListView *imagesView;

@property (nonatomic) Note *note;

- (void)setupNavigationBar;
- (void)updateView;

@end

