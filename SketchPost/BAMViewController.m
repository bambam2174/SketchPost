//
//  BAMViewController.m
//  SketchPost
//
//  Created by Sedat Kilinc on 04.03.13.
//  Copyright (c) 2013 adrodev GmbH. All rights reserved.
//

#define ACTIVITY_INDCTR 19182736

#import "BAMViewController.h"
#import "NSDictionary+Plist.h"

@interface BAMView (private)

@end

@implementation BAMView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _volumeView = [[MPVolumeView alloc] initWithFrame:self.bounds];
        _volumeView.frame = CGRectOffset(_volumeView.frame, 0, -_volumeView.frame.size.height);
        [self addSubview:_volumeView];
        _profilePictureView = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(10, 10, 75, 75)];
        _profilePictureView.backgroundColor = [UIColor clearColor];
        _profilePictureView.layer.cornerRadius = 10.0f;
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

-(void)layoutSubviews {
    _btnStart.frame = CGRectMake(10, self.frame.size.height-30, 100, 30);
    _btnFriends.frame = CGRectMake(self.frame.size.width-110, self.frame.size.height-30, 100, 30);
}

- (void)addButtonStart
{
    _btnStart = [[UIButton alloc] initWithFrame:CGRectMake(10, self.frame.size.height-30, 100, 30)];
    _btnStart.layer.cornerRadius = 10.0f;
    _btnStart.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
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
    _btnFriends.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [_btnFriends setBackgroundColor:[UIColor blackColor]];
    [_btnFriends setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnFriends setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    [_btnFriends setTitle:@"Friends" forState:UIControlStateNormal];
    
    [self addSubview:_btnFriends];
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

-(void)setDeviceOrientation:(UIDeviceOrientation)orientation {
    if (UIDeviceOrientationIsPortrait(orientation)) {
        _btnStart.frame = CGRectMake(10, self.frame.size.height-30, 100, 30);
        _btnFriends.frame = CGRectMake(120, self.frame.size.height-30, 100, 30);
    } else if (UIDeviceOrientationIsLandscape(orientation)) {
        _btnStart.frame = CGRectMake(10, self.frame.size.width-30, 100, 30);
        _btnFriends.frame = CGRectMake(120, self.frame.size.width-30, 100, 30);
    }
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
    m_sketchController.view.frame = [UIScreen mainScreen].bounds;
    m_sketchController.view.autoresizesSubviews = YES;
    m_sketchController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    m_sketchController.delegate = self;
//    [self.navigationController.navigationBar addSubview:[m_sketchController.navigationController.navigationBar.subviews objectAtIndex:0]];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe_Gest:)];
    swipeLeft.numberOfTouchesRequired = 2;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [m_sketchController.view addGestureRecognizer:swipeLeft];
    [self.view addSubview:m_sketchController.view];
    [self setupOtherView];
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionSetActive(true);
    AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume, audioVolumeChangeListenerCallback, (__bridge void *)(self));
}

-(void)viewDidAppear:(BOOL)animated {
    [self flipToOtherView:nil];
}

void audioVolumeChangeListenerCallback(void *inUserData, AudioSessionPropertyID inID, UInt32 inDataSize, const void *inData) {
    NSLog(@"%@", inUserData);
    NSLog(@"%f", *(Float32 *)inData);
    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_CurrentHardwareOutputVolume, NULL, NULL);
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
    _otherView.autoresizesSubviews = YES;
    _otherView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
    [self presentViewController:_friendsPicker animated:YES completion:^{
        NSLog(@"FINISHED");
    }];
}

#pragma mark - BAMFacebookManagerDelegate

-(void)userDetailsFetched:(NSDictionary<FBGraphUser> *)user {
    [_otherView setUser:user];
//    [user writeToPlistWithFilename:@"user_atomically.plist"];
}

-(void)friendspickerDoneWasPressed:(id)sender {
    NSLog(@"selectedFriends %@", [BAMFacebookManager shared].selectedFriends);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)friendspickerCancelWasPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)fbRequestDidFinishWithResult:(id)result error:(NSError *)err {
    [self hideActivityIndicator];
}

#pragma mark - ADDRAWViewControllerDelegate

-(void)swipeGesture:(UISwipeGestureRecognizerDirection)direction {
    
}

- (void) OnSketchADDRAWViewControllerCancel:(ADDRAWViewController*)ctrl {
    
}

- (void) OnSketchADDRAWViewController:(ADDRAWViewController *)ctrl saveImage:(UIImage*)image {
    [self showActivityIndicator];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)(self));
    [[BAMFacebookManager shared] uploadImage:image delegate:self];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"image %p, error %@, contextInfo %@", image, error, contextInfo);
}

#pragma mark - 

-(void)showActivityIndicator {
    if(!_graySheet) {
        _graySheet = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _graySheet.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        UIActivityIndicatorView *actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        actInd.tag = ACTIVITY_INDCTR;
        [actInd startAnimating];
        [_graySheet addSubview:actInd];
        actInd.frame = CGRectOffset(actInd.frame, (_graySheet.bounds.size.width-actInd.bounds.size.width)/2, (_graySheet.bounds.size.height-actInd.bounds.size.height)/2);
        _graySheet.frame = CGRectOffset(_graySheet.frame, 0, _graySheet.bounds.size.height);
    }
    [self.view addSubview:_graySheet];
    UIActivityIndicatorView *tmpAct = (UIActivityIndicatorView *)[_graySheet viewWithTag:ACTIVITY_INDCTR];
    [UIView animateWithDuration:.3 animations:^{
        _graySheet.frame = CGRectOffset(_graySheet.frame, 0, -_graySheet.bounds.size.height);
        [tmpAct startAnimating];
    }];
}

-(void)hideActivityIndicator {
    if(!_graySheet)
        return;
    UIActivityIndicatorView *tmpAct = (UIActivityIndicatorView *)[_graySheet viewWithTag:ACTIVITY_INDCTR];
    [UIView animateWithDuration:.3 animations:^{
        _graySheet.frame = CGRectOffset(_graySheet.frame, 0, _graySheet.bounds.size.height);
        [tmpAct stopAnimating];
    } completion:^(BOOL finished) {
        [_graySheet removeFromSuperview];
    }];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    LOG_METHOD2
    //[_otherView setDeviceOrientation:toInterfaceOrientation];
    /*
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        NSLog(@"Portrait : %@", NSStringFromCGRect(self.view.frame));
        
//        _otherView.frame = self.view.frame;
    } else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        NSLog(@"Landscape : %@", NSStringFromCGRect(self.view.frame));
        _otherView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
//        _otherView.frame = self.view.frame;
    }
    */
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (UIDeviceOrientationIsPortrait(fromInterfaceOrientation))
        NSLog(@"Landscape");
    else
        NSLog(@"Protrait");
    NSLog(@"self.view.frame %@", NSStringFromCGRect(self.view.frame));
    _otherView.frame = self.view.frame;
    m_sketchController.view.frame = self.view.frame;
}

//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    if (fromInterfaceOrientation == UIInterfaceOrientationPortrait || fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
//        NSLog(@"Portrait : %@", NSStringFromCGRect(self.view.frame));
//        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.height, self.view.frame.size.width);
//    } else if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//        NSLog(@"Landscape : %@", NSStringFromCGRect(self.view.frame));
//        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
//    }
//}



-(BOOL)shouldAutorotate {
    LOG_METHOD2
    UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIInterfaceOrientationPortrait) {
        NSLog(@"Portrait : %@", NSStringFromCGRect(self.view.frame));
    } else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        NSLog(@"Landscape : %@", NSStringFromCGRect(self.view.frame));
    }
    if(_isOtherViewVisible)
        return YES;
    else
        return NO;
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}




@end
