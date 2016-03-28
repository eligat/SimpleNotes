
#import "EditNoteVC.h"
#import "DataManager.h"
#import "Note+CoreDataProperties.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface EditNoteVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;

@property (nonatomic) Note *tmpNote;
@property (nonatomic) UIImagePickerController *imagePicker;

@end


@implementation EditNoteVC

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.addImageButton addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Accessors

- (void)setNote:(Note *)note {
    [super setNote:note];
    _tmpNote = [[DataManager sharedManager] newTemporaryNoteWithNote:note];
}

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [UIImagePickerController new];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.allowsEditing = NO;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}


#pragma mark - Actions

- (void)addImage:(id)sender {
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSURL *refURL = (NSURL *)info[UIImagePickerControllerReferenceURL];
    Image *img = [[DataManager sharedManager] newImageWithReferenceURL:refURL];
    tmp.note 
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
