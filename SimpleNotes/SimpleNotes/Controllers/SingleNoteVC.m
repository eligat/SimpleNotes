
#import "SingleNoteVC.h"
#import "Note.h"
#import "UITextView+Placeholder.h"

#import "DataManager.h"
#import "NYTRealPhoto.h"

static NSString * const EditNoteSegueID = @"EditNoteSegue";


@interface SingleNoteVC ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageListHeight;
@property (weak, nonatomic) IBOutlet UILabel *createdLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedLabel;

@property (nonatomic) NSMutableArray *nytPhotos;

@end


@implementation SingleNoteVC

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _nytPhotos = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageList.delegate = self;
    [self setupNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateView];
}


#pragma mark - Accessors

- (void)setNote:(Note *)note{
    _note = note;
    [self updateView];
}


#pragma mark - Actions

- (void)editButtonPressed:(id)sender {
    [self performSegueWithIdentifier:EditNoteSegueID sender:self];
}


#pragma mark - Public

- (void)updateView {
    self.nameLabel.text = self.note.name;
    self.textView.text = self.note.text;
    if (!self.note.text.length) {
        self.textView.placeholder = @"Text";
    }
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.locale = [NSLocale currentLocale];
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
        dateFormatter.dateFormat = @"dd.MM.yyyy  HH:mm:ss";
    }
    self.createdLabel.text = [dateFormatter stringFromDate:self.note.created];
    self.updatedLabel.text = [dateFormatter stringFromDate:self.note.updated];
    
    
    CGSize thumbnailImageSize = CGSizeMake(self.imageList.bounds.size.width, self.imageList.imageHeight);
    typeof(self) __weak wself = self;
    [DataManager fetchThumbnailImagesForNote:wself.note
                                 ofTargerSize:thumbnailImageSize
                                   completion:^(NSArray<UIImage *> *images) {
                                       
                                       wself.imageList.images = images;
                                       wself.imageListHeight.constant = wself.imageList.contentSize.height;
                                    
                                       [wself updateNYTPhotos];
                                   }];
}

- (void)setupNavigationBar {
    // Back button
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    // Edit button
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(editButtonPressed:)];
    self.navigationItem.rightBarButtonItem = edit;
}


#pragma mark - Private

- (void)updateNYTPhotos {
    NSMutableArray *photos = [NSMutableArray new];
    for (UIImage *img in self.imageList.images) {
        NYTRealPhoto *photo = [NYTRealPhoto new];
        photo.image = img;
        [photos addObject:photo];
    }
    
    _nytPhotos = photos;
}


#pragma mark - ImageListViewDelegate

- (void)imageList:(ImageListView *)imageList imageCellTapped:(ImageListCell *)imageCell {
    NSInteger index = [imageList indexOfCell:imageCell];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:self.nytPhotos
                                                                                       initialPhoto:self.nytPhotos[index]];
    photosViewController.delegate = self;
    [self presentViewController:photosViewController animated:YES completion:nil];
}


#pragma mark - NYTPhotosViewControllerDelegate

- (UIView * _Nullable)photosViewController:(NYTPhotosViewController *)photosViewController referenceViewForPhoto:(id <NYTPhoto>)photo {
    NSInteger index = [self.nytPhotos indexOfObject:photo];
    return (UIView *)[self.imageList cellAtIndex:index];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:EditNoteSegueID]) {
        SingleNoteVC *noteVC = (SingleNoteVC *)segue.destinationViewController;
        noteVC.note = self.note;
    }
}

@end
