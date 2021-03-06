//
//  BAMLoginController.m
//  SketchPost
//
//  Created by Sedat Kilinc on 06.03.13.
//  Copyright (c) 2013 adrodev GmbH. All rights reserved.
/*  All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the <organization> nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

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
    [appDelegate openPublishSession];
}

-(void)loginFailed {
    [_spinner stopAnimating];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
