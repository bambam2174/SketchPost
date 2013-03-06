//
//  BAMViewController.m
//  SketchPost
//
//  Created by Sedat Kilinc on 04.03.13.
//  Copyright (c) 2013 adrodev GmbH. All rights reserved.
//

#import "BAMViewController.h"
#import "ADDRAWViewController.h"

@interface BAMViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)logoutButtonWasPressed:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
}


@end
