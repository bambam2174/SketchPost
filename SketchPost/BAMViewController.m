//
//  BAMViewController.m
//  SketchPost
//
//  Created by Sedat Kilinc on 04.03.13.
//  Copyright (c) 2013 adrodev GmbH. All rights reserved.
//

#import "BAMViewController.h"
#import "NSDictionary+Plist.h"

@interface BAMView (private)

@end

@implementation BAMView

- (void)addButtonStart
{
    _btnStart = [[UIButton alloc] initWithFrame:CGRectMake(10, self.frame.size.height-30, 100, 30)];
    _btnStart.layer.cornerRadius = 10.0f;
    [_btnStart setBackgroundColor:[UIColor blackColor]];
    [_btnStart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnStart setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    [_btnStart setTitle:@"Klick" forState:UIControlStateNormal];
    
    [self addSubview:_btnStart];
}

- (void)addButtonFriends
{
    _btnFriends = [[UIButton alloc] initWithFrame:CGRectMake(120, self.frame.size.height-30, 100, 30)];
    _btnFriends.layer.cornerRadius = 10.0f;
    [_btnFriends setBackgroundColor:[UIColor blackColor]];
    [_btnFriends setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnFriends setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    [_btnFriends setTitle:@"Friends" forState:UIControlStateNormal];
    
    [self addSubview:_btnFriends];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _profilePictureView = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(10, 10, 75, 75)];
        _profilePictureView.backgroundColor = [UIColor clearColor];
        [self addSubview:_profilePictureView];
        
        _lblStuff = [[UILabel alloc] initWithFrame:CGRectMake(95, 10, 200, 25)];
        _lblStuff.backgroundColor = [UIColor clearColor];
        [self addSubview:_lblStuff];
        
        _lblStuff.text = @"HalloWelt HelloWorld Merhaba Dünya";
        self.backgroundColor = [UIColor redColor];
        
        [self addButtonStart];
        [self addButtonFriends];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - Public Methods

-(void)addButtonStartTarget:(id)target action:(SEL)selector {
    [_btnStart addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

-(void)addButtonFriendTarget:(id)target action:(SEL)selector {
    [_btnFriends addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

-(void)setUser:(NSDictionary<FBGraphUser> *)user {
    _user = user;
//    _lblStuff.text = user.name;
    _profilePictureView.profileID = user.id;
    _lblStuff.text = user.name;
    
}

@end

#pragma mark -
/*
################################################################################################################################
################################################################################################################################
*/
#pragma mark -


@interface BAMViewController (private)

@end

@implementation BAMViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView {
    [super loadView];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    m_sketchController = [[ADDRAWViewController alloc] init];
    m_sketchController.view.frame = [UIScreen mainScreen].bounds ;
    m_sketchController.delegate = self;
//    [self.navigationController.navigationBar addSubview:[m_sketchController.navigationController.navigationBar.subviews objectAtIndex:0]];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe_Gest:)];
    swipeLeft.numberOfTouchesRequired = 2;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [m_sketchController.view addGestureRecognizer:swipeLeft];
    [self.view addSubview:m_sketchController.view];
    [self setupOtherView];
}

-(void)viewDidAppear:(BOOL)animated {
    [self flipToOtherView:nil];
}

-(void)flipToOtherView:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    
    [self.view addSubview:_otherView];
    [UIView commitAnimations];
}

-(void)flipBack:(id)sender {
    if (_otherView) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        [_otherView removeFromSuperview];
        _isOtherViewVisible = NO;
        [UIView commitAnimations];
    }
    
}

-(void)setupOtherView {
    _otherView = [[BAMView alloc] initWithFrame:self.view.bounds];
    UISwipeGestureRecognizer *swipeBack = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBack_Gest:)];
    swipeBack.numberOfTouchesRequired = 1;
    swipeBack.direction = UISwipeGestureRecognizerDirectionLeft;
    [_otherView addGestureRecognizer:swipeBack];
    [_otherView addButtonStartTarget:self action:@selector(btnStart_Clicked:)];
    [_otherView addButtonFriendTarget:self action:@selector(btnFriends_Clicked:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)logoutButtonWasPressed:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
}

-(void)swipeBack_Gest:(id)sender {
    [self flipBack:sender];
}

-(void)swipe_Gest:(id)sender {
    [self flipToOtherView:nil];
}

-(void)btnStart_Clicked:(id)sender {
    _mgr = [BAMFacebookManager shared];
    _mgr.delegate = self;
    [_mgr getUserDetails];
}

-(void)btnFriends_Clicked:(id)sender {
    _friendsPicker = [[BAMFacebookManager shared] friendsPickerController];
//    [self.navigationController pushViewController:_friendsPicker animated:YES];
    [self presentViewController:_friendsPicker animated:YES completion:^{
        NSLog(@"FINISHED");
    }];
}

#pragma mark - BAMFacebookManagerDelegate

-(void)userDetailsFetched:(NSDictionary<FBGraphUser> *)user {
    [_otherView setUser:user];
//    [user writeToPlistWithFilename:@"user_atomically.plist"];

    
}

#pragma mark - ADDRAWViewControllerDelegate

-(void)swipeGesture:(UISwipeGestureRecognizerDirection)direction {
    
}

- (void) OnSketchADDRAWViewControllerCancel:(ADDRAWViewController*)ctrl {
    
}

- (void) OnSketchADDRAWViewController:(ADDRAWViewController *)ctrl saveImage:(UIImage*)image {
    
}

@end
