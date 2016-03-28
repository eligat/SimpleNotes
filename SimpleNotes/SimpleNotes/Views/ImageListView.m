
#import "ImageListView.h"
#import "ImageListCell.h"

static const CGFloat DefaultCellHeight = 80;
static NSString * const ImageListCellID = @"ImageListCell";

@interface ImageListView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic) UICollectionView *collectionView;

@end


@implementation ImageListView

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    _imageHeight = DefaultCellHeight;
    
    UICollectionViewLayout *layout = [UICollectionViewFlowLayout new];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ImageListCell class] forCellWithReuseIdentifier:ImageListCellID];
    
    
    [self addSubview:_collectionView];
}


#pragma mark - Accessors
- (void)setImages:(NSArray<UIImage *> *)images {
    _images = images;
    [self.collectionView reloadData];
}

- (CGSize)contentSize {
    return self.collectionView.collectionViewLayout.collectionViewContentSize;
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageListCellID forIndexPath:indexPath];
    cell.userInteractionEnabled = YES;
    
    
    // Add gesture recognizers
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.3;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [cell addGestureRecognizer:longPress];
    [cell addGestureRecognizer:tap];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[ImageListCell class]]) {
        ImageListCell *imageCell = (ImageListCell *)cell;
        UIImage *img = self.images[indexPath.row];
        
        // Configure cell
        imageCell.imageView.image = img;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(collectionViewLayout.collectionViewContentSize.width, _imageHeight);
    return size;
}


#pragma mark - Gestures

- (void)handleLongPress:(UILongPressGestureRecognizer *)recogniser {
    if (recogniser.state == UIGestureRecognizerStateBegan) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageList:imageCellLongPressed:)]) {
            ImageListCell *imageCell = (ImageListCell *)recogniser.view;
            [self.delegate imageList:self imageCellLongPressed:imageCell];
        }
        
    }
}

- (void)handleTap:(UITapGestureRecognizer *)recogniser {
    if (recogniser.state == UIGestureRecognizerStateBegan) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageList:imageCellTapped:)]) {
            ImageListCell *imageCell = (ImageListCell *)recogniser.view;
            [self.delegate imageList:self imageCellTapped:imageCell];
        }
        
    }
}

@end
