
#import "SingleNoteVC.h"
#import "Note.h"
#import "ImageListView.h"
#import "UITextView+Placeholder.h"

#import "DataManager.h"

static NSString * const EditNoteSegueID = @"EditNoteSegue";


@interface SingleNoteVC () <ImageListViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet ImageListView *imagesView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesViewHeight;

@end


@implementation SingleNoteVC

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagesView.delegate = self;
    
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
    
    
    CGSize thumbnailImageSize = CGSizeMake(self.imagesView.bounds.size.width, self.imagesView.imageHeight);
    [[DataManager sharedManager] fetchThumbnailImagesForNote:self.note
                                                ofTargerSize:thumbnailImageSize
                                                  completion:^(NSArray<UIImage *> *images) {
                                                      
                                                      self.imagesView.images = images;
                                                      self.imagesViewHeight.constant = self.imagesView.contentSize.height;
                                                      
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


#pragma mark - ImageListViewDelegate

- (void)imageList:(ImageListView *)imageList imageCellTapped:(ImageListCell *)imageCell {
    NSLog(@"%s", __func__);
}

- (void)imageList:(ImageListView *)imageList imageCellLongPressed:(ImageListCell *)imageCell {
    NSLog(@"%s", __func__);
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:EditNoteSegueID]) {
        SingleNoteVC *noteVC = (SingleNoteVC *)segue.destinationViewController;
        noteVC.note = self.note;
    }
}

@end
