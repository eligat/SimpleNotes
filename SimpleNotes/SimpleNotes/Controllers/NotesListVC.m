
#import "NotesListVC.h"
#import "SingleNoteVC.h"
#import "Note+CoreDataProperties.h"
#import "NoteTVC.h"
#import "NoteTVCModel.h"
#import "UISplitViewController+ChildrenAccess.h"

static NSString * const NoteCellID = @"NoteTVC";


@interface NotesListVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NoteTVCModel *noteCellModel;

@end


@implementation NotesListVC

#pragma mark - Lifecycle

- (void)commonInit {
    _noteCellModel = [NoteTVCModel new];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[NoteTVC class] forCellReuseIdentifier:NoteCellID];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


#pragma mark - Accessors

- (void)setNotes:(NSArray<Note *> *)notes{
    _notes = notes;
    [self reload];
}


#pragma mark - Private

- (void)reload {
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NoteCellID forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[NoteTVC class]]) {
        NoteTVC *noteCell = (NoteTVC *)cell;
        Note *note = self.notes[indexPath.row];
        
        [self.noteCellModel configireNoteCell:noteCell forNote:note];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SingleNoteVC *detailVC = (SingleNoteVC *)self.splitViewController.detailVC;
    [self.splitViewController showDetailViewController:detailVC sender:self];
}

@end
