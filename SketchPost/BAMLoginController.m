//
//  BAMLoginController.m
//  SketchPost
//
//  Created by Sedat Kilinc on 06.03.13.
//  Copyright (c) 2013 adrodev GmbH. All rights reserved.
//

#define CTRL_WIDTH 200.0f

#import "BAMLoginController.h"
#import "ADSBorderedTextfield.h"
#import "BAMAppDelegate.h"

@interface BAMLoginController ()

@end

@implementation BAMLoginController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor blackColor];
//        _tfUsername = [self addTextfieldAtY:100];
//        _tfPassword = [self addTextfieldAtY:150];
        _btnLogin = [[UIButton alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-CTRL_WIDTH)/2, 300, CTRL_WIDTH, 42)];
        _btnLogin.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _btnLogin.layer.borderWidth = 1.0f;
        _btnLogin.layer.cornerRadius = 10.0f;
        [_btnLogin setTitle:@"Login" forState:UIControlStateNormal];
        [_btnLogin addTarget:self action:@selector(btnLogin_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btnLogin];
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:_spinner];
        _spinner.hidesWhenStopped = YES;
        _spinner.frame = CGRectOffset(_spinner.frame, (self.view.bounds.size.width-_spinner.bounds.size.width)/2, 200);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(ADSBorderedTextfield *)addTextfieldAtY:(CGFloat)y {
    ADSBorderedTextfield *tmpTextfield = [[ADSBorderedTextfield alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-CTRL_WIDTH)/2, y, CTRL_WIDTH, 42)];
    tmpTextfield.delegate = self;
    tmpTextfield.backgroundColor = CLEAR_COLOR;
    [tmpTextfield setTextColor:[UIColor whiteColor]];
    [self.view addSubview:tmpTextfield];
    return tmpTextfield;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"_tfUsername %@, _tfPassword %@", _tfUsername.text, _tfPassword.text);
    [textField resignFirstResponder];
    if (textField ==_tfUsername && _tfPassword.text == nil)
        [_tfPassword becomeFirstResponder];
    else if (_tfUsername.text == nil)
        [_tfUsername becomeFirstResponder];
    else
        [_btnLogin becomeFirstResponder];
    return YES;
}

-(void)btnLogin_Clicked:(UIButton *)sender {
    LOG_METHOD2
    [_spinner startAnimating];
    BAMAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
}

-(void)loginFailed {
    [_spinner stopAnimating];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
