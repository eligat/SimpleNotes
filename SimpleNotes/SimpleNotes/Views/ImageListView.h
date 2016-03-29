
#import <UIKit/UIKit.h>


@class ImageListView, ImageListCell;


@protocol ImageListViewDelegate <NSObject>
- (void)imageList:(ImageListView *)imageList imageCellTapped:(ImageListCell *)imageCell;
- (void)imageList:(ImageListView *)imageList imageCellLongPressed:(ImageListCell *)imageCell;

@end


@interface ImageListView : UIView
@property (weak, nonatomic) id<ImageListViewDelegate> delegate;
@property (nonatomic) NSArray<UIImage *> *images;

@property (nonatomic) CGFloat imageHeight;
@property (nonatomic, readonly) CGSize contentSize;

- (NSInteger)indexOfCell:(ImageListCell *)cell;

@end
