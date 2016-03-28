
#import "SingleNoteVC.h"
#import "Note.h"
#import "ImageListView.h"

static NSString * const EditNoteSegueID = @"EditNoteSegue";


@interface SingleNoteVC ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *imagesView;

@end


@implementation SingleNoteVC

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self updateView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - Private
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

- (void)updateView {
    self.nameLabel.text = self.note.name;
    self.textView.text = self.note.text;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:EditNoteSegueID]) {
        SingleNoteVC *noteVC = (SingleNoteVC *)segue.destinationViewController;
        noteVC.note = self.note;
    }
}

@end
