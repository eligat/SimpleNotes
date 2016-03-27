
#import "NoteTVCModel.h"
#import "Note+CoreDataProperties.h"
#import "NoteTVC.h"


@implementation NoteTVCModel

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.locale = [NSLocale currentLocale];
        formatter.timeZone = [NSTimeZone localTimeZone];
        formatter.dateFormat = @"dd.MM.yyyy";
        
        _dateFormatter = formatter;
    }
    
    return self;
}

#pragma mark - Public

- (void)configireNoteCell:(NoteTVC *)cell forNote:(Note *)note {
    NSString *name = note.name ? note.name : @"";
    cell.nameLabel.text = name;
    
    cell.updateLabel.text = [self.dateFormatter stringFromDate:note.updated];
}

@end
