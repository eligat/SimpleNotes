
#import "EditNoteVC.h"
#import "DataManager.h"
#import "Note+CoreDataProperties.h"
#import "Image+CoreDataProperties.h"

#import "ImageListView.h"
#import "GMImagePickerController.h"


static const CGFloat DefaultDeleteButtonHeight = 30;


@interface EditNoteVC () <GMImagePickerControllerDelegate, UITextViewDelegate, ImageListViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteButtonHeight;

@property (nonatomic) BOOL noteIsNew;
@property (nonatomic) BOOL saved;
@property (nonatomic) Note *originalNote;
@property (nonatomic) NSMutableArray<Image *> *tmpImages;
@property (nonatomic) Note *tmpNote;
@property (nonatomic) GMImagePickerController *imagePicker;

@end


@implementation EditNoteVC

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _tmpImages = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagesView.delegate = self;
    self.textView.delegate = self;
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.addImageButton addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.noteIsNew) {
        self.deleteButtonHeight.constant = 0;
        self.deleteButton.hidden = YES;
        
    } else {
        self.deleteButtonHeight.constant = DefaultDeleteButtonHeight;
        self.deleteButton.hidden = NO;
        
    }
    
    [self.view layoutIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        [self cleanUpAndSave];
    }
}


#pragma mark - Accessors

- (Note *)note {
    return _tmpNote;
}

- (void)setNote:(Note *)note {
    [super setNote:note];
    
    _originalNote = note;
    _tmpNote = [DataManager newTemporaryNoteWithNote:note];
    [_tmpImages removeAllObjects];
    _noteIsNew = !note;
    _saved = NO;
}

- (GMImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [GMImagePickerController new];
        _imagePicker.mediaTypes = @[@(PHAssetMediaTypeImage)];
        _imagePicker.customDoneButtonTitle = @"Done";
        _imagePicker.customCancelButtonTitle = @"Cancel";
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}


#pragma mark - Actions

- (void)addImage:(UIButton *)sender {
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)delete:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Delete note"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *deleteAction = [UIAlertAction
                                  actionWithTitle:NSLocalizedString(@"Delete", @"Delete action")
                                  style:UIAlertActionStyleDestructive
                                  handler:^(UIAlertAction *action)
                                  {
                                      [self deleteNote];
                                      [self cleanUpAndSave];
                                      [self.navigationController.navigationController popToRootViewControllerAnimated:YES];
                                      
                                  }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)save:(UIBarButtonItem *)sender {
    if (self.noteIsNew) {
        self.originalNote = [DataManager newTemporaryNoteWithNote:_tmpNote];
        
    } else {
        self.originalNote.name = _tmpNote.name;
        self.originalNote.text = _tmpNote.text;
        self.originalNote.images = _tmpNote.images;
        self.originalNote.updated = [NSDate date];
    }
    
    if (![self validateNote:self.originalNote]) {
        [self deleteNote];
        
    }
    
    self.saved = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidChange:(UITextField *)textField {
    _tmpNote.name = textField.text;
}


#pragma mark - Private
- (void)deleteNote {
    if (self.originalNote) {
        for (Image *img in self.originalNote.images) {
            [img MR_deleteEntity];
        }
        
        [self.originalNote MR_deleteEntity];
    }
}

- (BOOL)validateNote:(Note *)note{
    if (!note.name.length) {
        return NO;
    }
    
    return YES;
}

- (void)cleanUpAndSave{
    if (!self.saved) {
        for (Image *img in self.tmpImages) {
            [img MR_deleteEntity];
        }
        
        _originalNote.images = _tmpNote.images;
    }
    
    [_tmpNote MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

#pragma mark - SingleNoteVC
- (void)setupNavigationBar {
    // Save button
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = save;
}

- (void)updateView {
    [super updateView];
    
    self.textField.text = _tmpNote.name;
}


#pragma mark - GMImagePickerControllerDelegate

- (void)assetsPickerController:(GMImagePickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    for (PHAsset *asset in assets) {
        Image *img = [DataManager newImageWithAsset:asset];
        [self.tmpImages addObject:img];
        [self.tmpNote addImagesObject:img];
    }
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    NSArray *selectedAssets = [picker.selectedAssets copy];
    for (PHAsset *asset in selectedAssets) {
        [picker deselectAsset:asset];
    }
    
    [self updateView];
}

- (void)assetsPickerControllerDidCancel:(GMImagePickerController *)picker {
    NSArray *selectedAssets = [picker.selectedAssets copy];
    for (PHAsset *asset in selectedAssets) {
        [picker deselectAsset:asset];
    }
}


#pragma mark - ImageListViewDelegate

- (void)imageList:(ImageListView *)imageList imageCellTapped:(ImageListCell *)imageCell {
    
}

- (void)imageList:(ImageListView *)imageList imageCellLongPressed:(ImageListCell *)imageCell {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Delete Image"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *deleteAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Delete", @"Delete action")
                                   style:UIAlertActionStyleDestructive
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSInteger index = [imageList indexOfCell:imageCell];
                                       if (index >= 0) {
                                           Image *img = [self.note.images objectAtIndex:index];
                                           [self.note removeImagesObject:img];
                                           [img MR_deleteEntity];
                                           [self updateView];
                                       }
                                       
                                   }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    _tmpNote.text = textView.text;
}


@end
