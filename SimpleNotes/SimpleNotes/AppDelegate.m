

#import "AppDelegate.h"
#import "UISplitViewController+ChildrenAccess.h"

#import <MagicalRecord/MagicalRecord.h>
#import "DataManager.h"

#import "Note.h"
#import "NotesListVC.h"


static NSString * const CoreDataStoreName = @"NotesData";

@interface AppDelegate () <UISplitViewControllerDelegate>
@property (nonatomic) DataManager *dataManager;
@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:CoreDataStoreName];
        _dataManager = [DataManager sharedManager];
    }
    
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UISplitViewController *splitVC = (UISplitViewController *)self.window.rootViewController;
    splitVC.delegate = self;
    
    NotesListVC *notesListVC = [(UINavigationController *)splitVC.masterVC viewControllers].firstObject;
    
    //======TEST======//
    NSArray *notes = [self.dataManager allNotes];
    if (!notes.count) {
        for (int i = 0; i < 5; ++i) {
            Note *note = [Note MR_createEntity];
            note.name = [NSString stringWithFormat:@"NOTE NAME %d", i];
            note.text = [NSString stringWithFormat:@"Note text %d", i];
        }
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    //======TEST======//
    
    notesListVC.notes = [self.dataManager allNotes];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    [MagicalRecord cleanUp];
}


#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController{
    
    return YES;
}

@end
