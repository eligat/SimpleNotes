
#import <UIKit/UIKit.h>

@class Note;

@interface SingleNoteVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic) Note *note;

- (void)setupNavigationBar;
- (void)updateView;

@end

