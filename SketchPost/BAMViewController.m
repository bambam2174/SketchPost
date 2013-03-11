//
//  BAMViewController.m
//  SketchPost
//
//  Created by Sedat Kilinc on 04.03.13.
//  Copyright (c) 2013 adrodev GmbH. All rights reserved.
//

#import "BAMViewController.h"
#import "ADDRAWViewController.h"

@interface BAMView (private)

@end

@implementation BAMView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _imvProfile = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 75, 75)];
        _imvProfile.backgroundColor = [UIColor clearColor];
        [self addSubview:_imvProfile];
        
        _lblStuff = [[UILabel alloc] initWithFrame:CGRectMake(95, 10, 200, 25)];
        _lblStuff.backgroundColor = [UIColor clearColor];
        [self addSubview:_lblStuff];
        
        _lblStuff.text = @"HalloWelt HelloWorld Merhaba Dünya";
        self.backgroundColor = [UIColor redColor];
        
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

@end

//################################################################################################################################
//################################################################################################################################

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
    m_sketchController.view.frame = self.view.bounds;
    [self.navigationController.navigationBar addSubview:[m_sketchController.navigationController.navigationBar.subviews objectAtIndex:0]];
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
    _otherView = [[BAMView alloc] initWithFrame:self.view.frame];
    UISwipeGestureRecognizer *swipeBack = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBack_Gest:)];
    swipeBack.numberOfTouchesRequired = 1;
    swipeBack.direction = UISwipeGestureRecognizerDirectionLeft;
    [_otherView addGestureRecognizer:swipeBack];
    
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

@end
