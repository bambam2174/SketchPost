//
//  ADDRAWViewController.m
//  DrawAppClient
//
//  Created by Sedat Kilinc on 06.03.12.
//  Copyright (c) 2012 Internship. All rights reserved.
//

#define FONT_SIZE 12
#define KORREKTURFAKTORY 1

#import "ADDRAWViewController.h"


@interface ADDRAWViewController ()

//-(void)navButton_Clicked:(id)sender;
-(void)openPicStuff;
-(void)slider_EventValueChanged:(id)sender;
-(void)slider_EventDragStop:(id)sender;
-(void)btnUndo_Clicked:(id)sender;
-(void)btnRedo_Clicked:(id)sender;
-(void)btnColor_Clicked:(id)sender;
-(void)btnColor_Done:(id)sender;
- (void)setupCustomView;
- (void)setupNavBar;
- (void)setupToolbar;
-(UIView *)setupColorComposer;
-(void)sliderRed_EventValueChanged:(id)sender;
-(void)sliderGreen_EventValueChanged:(id)sender;
-(void)sliderBlue_EventValueChanged:(id)sender;
-(void)sliderAlpha_EventValueChanged:(id)sender;
-(void)setupCanvas;
-(void)drawHistory;
-(void)textButton_Clicked:(id)sender;
-(void)drawString:(NSString *)value atPoint:(CGPoint)punkt;
-(void)navBtnBack_Clicked:(id)sender;
-(void)navBtnSave_Clicked:(id)sender;
-(void)segmentControlEvent:(id)sender;
-(void)btnColor_Picked:(id)sender;
-(UIImage *)rotate:(UIImage *)src withDegrees:(double)degrees;
static inline double radians (double degrees);
-(void) _drawBackgroundImage;

@end

@implementation ADDRAWViewController

@synthesize delegate = _delegate;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Constructor Destructor

-(id)init {
    LOG_METHOD
    self = [super init];
    if (self) {
        _arrPaths = [[NSMutableArray alloc] init];
        dictPaths = [[NSMutableDictionary alloc] init];
        pc = 0;
//        lastPC = 0;
        red = 1.0;
        green = 0.0;
        blue = 0.0;
        alpha = 1.0;
        drawText = NO;
        overlayFont = nil;
        canvas2Top = NO;
        vOffset = 0.0;
        _topToolBarVisible = NO;
        _bottomToolBarVisible = NO;
    }
    return self;
}



#pragma mark - View lifecycle

-(void)loadView {
    [super loadView];
    [self.navigationController setNavigationBarHidden:YES];
    [self setupCustomView];
    [self setupCanvas];
    colorPicker = [self setupColorComposer];
    [self.view addSubview:colorPicker];
    [self setupNavBar];
    [self setupToolbar];
    //    self.view.layer.delegate = self;
    UISwipeGestureRecognizer *swipeUpGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedUp:)];
    swipeUpGest.numberOfTouchesRequired = 2;
    swipeUpGest.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUpGest];
    
    
    UISwipeGestureRecognizer *swipeDownGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedDown:)];
    swipeDownGest.numberOfTouchesRequired = 2;
    swipeDownGest.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownGest];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    need2turn = NO;
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    tmpImgVw = nil;
    _lblAnzeige = nil;
    _lblTopAnzeige = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/*
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
*/



- (bool) hasChanges
{
    return (dictPaths.count);
}

-(void)swipedUp:(id)sender {
    LOG_METHOD2
    [UIView animateWithDuration:0.3 animations:^{
        if (_topToolBarVisible) {
            _topToolBar.frame = CGRectOffset(_topToolBar.frame, 0, -_topToolBar.bounds.size.height);
            tBar.frame = CGRectOffset(tBar.frame, 0, -tBar.bounds.size.height);
            _topToolBarVisible = NO;
            _bottomToolBarVisible = NO;
        } else  {
            _topToolBar.frame = CGRectOffset(_topToolBar.frame, 0, _topToolBar.bounds.size.height);
            tBar.frame = CGRectOffset(tBar.frame, 0, tBar.bounds.size.height);
            _topToolBarVisible = YES;
            _bottomToolBarVisible = YES;
        }
    }];
    
    [_delegate swipeGesture:UISwipeGestureRecognizerDirectionUp];
}


-(void)swipedDown:(id)sender {
    LOG_METHOD2
    [_delegate swipeGesture:UISwipeGestureRecognizerDirectionDown];
}

#pragma mark - UI Elements

-(UIView *)setupColorComposer {
    UIView *tmpView;
    tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-44, self.view.bounds.size.width, 300)];
    [tmpView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
    
    UISlider *sliderRed = [[UISlider alloc] initWithFrame:CGRectMake((tmpView.frame.size.width-160)/2, 30, 160, 30)];
    [sliderRed setMinimumValue:0.0];
    [sliderRed setMaximumValue:1.0];
    sliderRed.value = red;
    [sliderRed addTarget:self action:@selector(sliderRed_EventValueChanged:) forControlEvents:UIControlEventValueChanged];
    [sliderRed addTarget:self action:@selector(slider_EventDragStop:) forControlEvents:UIControlEventTouchUpInside];
    [tmpView addSubview:sliderRed];
    
    UISlider *sliderGreen = [[UISlider alloc] initWithFrame:CGRectMake((tmpView.frame.size.width-160)/2, 80, 160, 30)];
    [sliderGreen setMinimumValue:0.0];
    [sliderGreen setMaximumValue:1.0];
    sliderGreen.value = green;
    [sliderGreen addTarget:self action:@selector(sliderGreen_EventValueChanged:) forControlEvents:UIControlEventValueChanged];
    [sliderGreen addTarget:self action:@selector(slider_EventDragStop:) forControlEvents:UIControlEventTouchUpInside];
    [tmpView addSubview:sliderGreen];
    
    UISlider *sliderBlue = [[UISlider alloc] initWithFrame:CGRectMake((tmpView.frame.size.width-160)/2, 130, 160, 30)];
    [sliderBlue setMinimumValue:0.0];
    [sliderBlue setMaximumValue:1.0];
    sliderBlue.value = blue;
    [sliderBlue addTarget:self action:@selector(sliderBlue_EventValueChanged:) forControlEvents:UIControlEventValueChanged];
    [sliderBlue addTarget:self action:@selector(slider_EventDragStop:) forControlEvents:UIControlEventTouchUpInside];
    [tmpView addSubview:sliderBlue];
    
    UISlider *sliderAlpha = [[UISlider alloc] initWithFrame:CGRectMake((tmpView.frame.size.width-160)/2, 180, 160, 30)];
    [sliderAlpha setMinimumValue:0.0];
    [sliderAlpha setMaximumValue:1.0];
    sliderAlpha.value = alpha;
    [sliderAlpha addTarget:self action:@selector(sliderAlpha_EventValueChanged:) forControlEvents:UIControlEventValueChanged];
    [sliderAlpha addTarget:self action:@selector(slider_EventDragStop:) forControlEvents:UIControlEventTouchUpInside];
    [tmpView addSubview:sliderAlpha];
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnDone setFrame:CGRectMake(30, 230, 120, 20)];
    [btnDone setTitle:@"DONE" forState:UIControlStateNormal];
    [btnDone.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    [btnDone.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btnDone addTarget:self action:@selector(btnColor_Done:) forControlEvents:UIControlEventTouchUpInside];
    [tmpView addSubview:btnDone];
    
    return tmpView;
}

- (void)setupCustomView {

//    [self.view.layer setBackgroundColor:[UIColor redColor].CGColor];
//    [self.view.layer setCornerRadius:20.0f];
//    [self.view.layer setMasksToBounds:YES];
    
}

- (void)setupNavBar {
//    self.navigationItem.title = @"Sketch it";
    _topToolBar = [[UIView alloc] initWithFrame:CGRectMake(/*self.view.bounds.size.width*/0, -44, self.view.bounds.size.width, 44)];
    _topToolBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:.3];
    [self.view addSubview:_topToolBar];
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnCancel setTitle:@"X" forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(navBtnBack_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [_topToolBar addSubview:btnCancel];
//    UIBarButtonItem *navBarButton = [[UIBarButtonItem alloc] initWithTitle:@"X" style:UIBarButtonItemStyleBordered target:self action:@selector(navBtnBack_Clicked:)];
//    self.navigationItem.leftBarButtonItem = navBarButton;
    UISegmentedControl *toolButtons = [[UISegmentedControl alloc] init] ;//WithItems:[NSArray arrayWithObjects:@"Linie", @"Bild laden", @"A", nil]];
    
    [toolButtons insertSegmentWithImage:[UIImage imageNamed:@"icon_skatch_line.png"]  atIndex:0 animated:true];
    [toolButtons insertSegmentWithImage:[UIImage imageNamed:@"icon_skatch_text.png"]  atIndex:1 animated:true];
    [toolButtons insertSegmentWithImage:[UIImage imageNamed:@"icon_skatch_pic.png"]  atIndex:2 animated:true];
    

    toolButtons.frame = CGRectMake(73, 7, 180, 30);
    toolButtons.segmentedControlStyle = UISegmentedControlStyleBar;
    toolButtons.selectedSegmentIndex = 0;
//    [self.navigationController.navigationBar addSubview:toolButtons];
    [_topToolBar addSubview:toolButtons];
    [toolButtons addTarget:self action:@selector(segmentControlEvent:) forControlEvents:UIControlEventValueChanged];
    
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(navBtnSave_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [_topToolBar addSubview:btnSave];
    btnSave.frame = CGRectOffset(btnSave.frame, self.view.bounds.size.width- btnSave.bounds.size.width, 0);
    NSLog(@"btnSave %@, btnCancel %@", NSStringFromCGRect(btnSave.frame), NSStringFromCGRect(btnCancel.frame));
//    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc] initWithTitle:@"SAVE" style:UIBarButtonItemStyleDone target:self action:@selector(navBtnSave_Clicked:)];
//    self.navigationItem.rightBarButtonItem = saveBarButton;
    
    /*UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    DLog(@"Navbar frame %@", NSStringFromCGRect(navBar.frame));
    [navBar setBarStyle:UIBarStyleBlack];
    [self.view addSubview:navBar]; */
    
/*    _lblTopAnzeige = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
    [_lblTopAnzeige setFont:[UIFont systemFontOfSize:10.0]];
    [_lblTopAnzeige setBackgroundColor:[UIColor clearColor]];
    [_lblTopAnzeige setTextColor:[UIColor blackColor]];
    [navBar addSubview:_lblTopAnzeige];*/
    
/*
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [navButton setFrame:CGRectMake(self.view.frame.size.width-65, (navBar.frame.size.height-20)/2, 60, 20)];
    [navButton addTarget:self action:@selector(navButton_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [navButton setTitle:@"Image" forState:UIControlStateNormal];
//    [navButton setBackgroundImage:[UIImage imageNamed:@"xeye.png"] forState:UIControlStateNormal];
    [navBar addSubview:navButton];
//    [navButton release];
    
//    textButton = [[UIButton alloc] initWithFrame:CGRectMake(35, (self.navigationController.navigationBar.frame.size.height-20)/2, 40, 20)];
    textButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [textButton setFrame:CGRectMake(self.view.frame.size.width-130, (navBar.frame.size.height-20)/2, 40, 20)];
    [textButton addTarget:self action:@selector(textButton_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [textButton.titleLabel setFont:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:12]];
    [textButton setTitle:@"A" forState:UIControlStateNormal];
//    [textButton setBackgroundImage:[UIImage imageNamed:@"xeye.png"] forState:UIControlStateNormal];
    [navBar addSubview:textButton];
    
    UIButton *navBtnSave = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [navBtnSave setFrame:CGRectMake(90, (navBar.frame.size.height-20)/2, 40, 20)];
    [navBtnSave addTarget:self action:@selector(navBtnSave_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [navBtnSave setTitle:@"Save" forState:UIControlStateNormal];
    //    [navButton setBackgroundImage:[UIImage imageNamed:@"xeye.png"] forState:UIControlStateNormal];
    [navBar addSubview:navBtnSave];
    
    UIButton *navBtnBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [navBtnBack setFrame:CGRectMake(35, (navBar.frame.size.height-20)/2, 50, 20)];
    [navBtnBack addTarget:self action:@selector(navBtnBack_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [navBtnBack setTitle:@"Back" forState:UIControlStateNormal];
    //    [navButton setBackgroundImage:[UIImage imageNamed:@"xeye.png"] forState:UIControlStateNormal];
    [navBar addSubview:navBtnBack];
    
    [navBar release];*/
}

- (void)setupToolbar {
        // Toolbar
    tBar = [[UIToolbar alloc] init];
    tBar.barStyle = UIBarStyleDefault;
    [tBar sizeToFit];
    tBar.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44);
    [self.view addSubview:tBar];
    
    
    
    _colorView = [[UIView alloc] initWithFrame:CGRectMake(0,5,150,30)];
    
        // Slider
    _widthSlider = [[UISlider alloc] initWithFrame:_colorView.frame];
    [_widthSlider setMinimumValue:0.0];
    [_widthSlider setMaximumValue:20.0];
    _widthSlider.value = 5.0;
    _radius = _widthSlider.value;
    [_widthSlider addTarget:self action:@selector(slider_EventValueChanged:) forControlEvents:UIControlEventValueChanged];

    
    
        // Colorpicker
    _colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_colorButton setFrame:CGRectMake(5, 2, 34, 34)];
    [_colorButton setImage:[UIImage imageNamed:@"icon_skatch_color.png"] forState:UIControlStateNormal];
    [_colorButton setImage:[UIImage imageNamed:@"icon_skatch_color.png"] forState:UIControlStateHighlighted];
    [_colorButton setShowsTouchWhenHighlighted:TRUE];
    //[_colorButton setTitle:@"Color" forState:UIControlStateNormal];
    //[_colorButton setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:alpha]];
    [_colorButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    [_colorButton addTarget:self action:@selector(btnColor_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _colorPoint = [[UIView alloc] initWithFrame:CGRectMake(12,11,4,4)];
    [_colorPoint setBackgroundColor:[UIColor redColor]];
    _colorPoint.layer.cornerRadius = 2;
    [_colorButton addSubview:_colorPoint];
    
    
    _widthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_widthButton setFrame:_colorButton.frame];
    [_widthButton setImage:[UIImage imageNamed:@"icon_skatch_intensity.png"] forState:UIControlStateNormal];
    [_widthButton setImage:[UIImage imageNamed:@"icon_skatch_intensity.png"] forState:UIControlStateHighlighted];
    [_widthButton setShowsTouchWhenHighlighted:TRUE];
    [_widthButton addTarget:self action:@selector(btnWidth_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    _widthButton.hidden = TRUE;
    
    //[Controls enlargeTouchArea:_colorButton];
    //[Controls enlargeTouchArea:_widthButton];
    
    
    /*
    UINavigationBar *navBarBottom = [[UINavigationBar alloc] init];
    [navBarBottom sizeToFit];
    navBarBottom.frame = CGRectMake(0, self.view.frame.size.height-88, self.view.frame.size.width, 44);
    [self.view addSubview:navBarBottom];
    
    UINavigationItem *navItemBottom = [[UINavigationItem alloc] init];
    [navBarBottom pushNavigationItem:navItemBottom animated:FALSE];
    */
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0,0,70,40)];
    _colorView.hidden = TRUE;
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake((tBar.frame.size.width-150)/2,2,150,40)];
    [centerView addSubview:_widthSlider];
    [centerView addSubview:_colorView];
    [centerView setUserInteractionEnabled:TRUE];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(tBar.frame.size.width-70,0,70,40)];
    [rightView addSubview:_colorButton];
    [rightView addSubview:_widthButton];
    _colorView.hidden = TRUE;
    
    
    
    [tBar addSubview:leftView];
    [tBar addSubview:centerView];
    [tBar addSubview:rightView];

    
    /*
    [leftView setBackgroundColor:[UIColor redColor]];
    [centerView setBackgroundColor:[UIColor blueColor]];
    [rightView setBackgroundColor:[UIColor greenColor]];
    */
    /*
    navItemBottom.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    [navBarBottom addSubview:centerView];
    navItemBottom.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    */
    
    
    
    
    UIButton *btnUndo = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnUndo setFrame:CGRectMake(8,5,30,30)];
    [btnUndo setImage:[UIImage imageNamed:@"icon_skatch_undo.png"] forState:UIControlStateNormal];
    [btnUndo setImage:[UIImage imageNamed:@"icon_skatch_undo.png"] forState:UIControlStateHighlighted];
    [btnUndo setShowsTouchWhenHighlighted:TRUE];
    [btnUndo addTarget:self action:@selector(btnUndo_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:btnUndo];
    
    UIButton *btnRedo = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRedo setFrame:CGRectMake(38,5,30,30)];
    [btnRedo setImage:[UIImage imageNamed:@"icon_skatch_redo.png"] forState:UIControlStateNormal];
    [btnRedo setImage:[UIImage imageNamed:@"icon_skatch_redo.png"] forState:UIControlStateHighlighted];
    [btnRedo setShowsTouchWhenHighlighted:TRUE];
    [btnRedo addTarget:self action:@selector(btnRedo_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:btnRedo];
    
    
    
    /*
    UIBarButtonItem *btnUndo = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_skatch_undo.png"] style:UIBarButtonItemStylePlain target:self action:@selector(btnUndo_Clicked:)];
    UIBarButtonItem *btnRedo = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_skatch_redo.png"] style:UIBarButtonItemStylePlain target:self action:@selector(btnRedo_Clicked:)];
    UIBarButtonItem *barBtnColor = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    UIBarButtonItem *btnSlider = [[UIBarButtonItem alloc] initWithCustomView:centerView];
    
    [tBar setItems:[NSArray arrayWithObjects:btnUndo, btnRedo, btnSlider, barBtnColor, nil]];
     */

    return;
    
    
    
        // Brushradius indicator
    _lblAnzeige = [[UILabel alloc] initWithFrame:CGRectMake(_widthSlider.frame.origin.x-20, _widthSlider.frame.origin.y+8, 20, 15)];
    [_lblAnzeige setBackgroundColor:[UIColor clearColor]];
    [_lblAnzeige setTextColor:[UIColor whiteColor]];
    [_lblAnzeige setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    _lblAnzeige.textAlignment = NSTextAlignmentCenter;
    
    [tBar addSubview:_lblAnzeige];
//        // Undo-Button
//    UIButton *btnUndo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btnUndo setFrame:CGRectMake(5, 15, 40, 20)];
//    [btnUndo setTitle:@"Undo" forState:UIControlStateNormal];
//    [btnUndo.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:10]];
//    [btnUndo addTarget:self action:@selector(btnUndo_Clicked:) forControlEvents:UIControlEventTouchUpInside];
//    [tBar addSubview:btnUndo];
////    [btnUndo release];
//    // Redo-Button
//    UIButton *btnRedo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btnRedo setFrame:CGRectMake(45, 15, 40, 20)];
//    [btnRedo setTitle:@"Redo" forState:UIControlStateNormal];
//    [btnRedo.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:10]];
//    [btnRedo addTarget:self action:@selector(btnRedo_Clicked:) forControlEvents:UIControlEventTouchUpInside];
//    [tBar addSubview:btnRedo];
////    [btnRedo release];
        
    
    
    
}

-(void)setupCanvas {
    tmpImgVw = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [tmpImgVw setBackgroundColor:[UIColor clearColor]];
    //[tmpImgVw setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:tmpImgVw];
}

#pragma mark - UI Element Events

//-(void)navButton_Clicked:(id)sender {
-(void)openPicStuff {
    LOG_METHOD
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@"Bildquelle" delegate:self cancelButtonTitle:@"CANCEL" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Album", @"Saved", nil];
    actSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actSheet showInView:self.view];
}

-(void)navBtnBack_Clicked:(id)sender {
    LOG_METHOD
    
    if([self hasChanges])
    {
        cancelAlertView = [[UIAlertView alloc] initWithTitle:@"Cancel?" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [cancelAlertView show];
    }
    else
    {
        [_delegate OnSketchADDRAWViewControllerCancel:self];
    }
    
}

-(void)navBtnSave_Clicked:(id)sender {
    LOG_METHOD
    [_delegate OnSketchADDRAWViewController:self saveImage:tmpImgVw.image];
}

-(void)slider_EventValueChanged:(id)sender {
    UISlider *tmpSlider = (UISlider *)sender;
    SKLog(@"%@ in %@ sender.value %f", NSStringFromSelector(_cmd), NSStringFromClass([self class]), tmpSlider.value);
    _radius = tmpSlider.value;
    [_lblAnzeige setText:[NSString stringWithFormat:@"%.1f", _radius]];
}

-(void)segmentControlEvent:(id)sender {
    LOG_METHOD
    UISegmentedControl *tmp = (UISegmentedControl *)sender;
    DLog(@"index %d", tmp.selectedSegmentIndex);
    switch (tmp.selectedSegmentIndex) {
        case 0:
            drawText = NO;
            break;
        case 1:
            [self textButton_Clicked:sender];
            break;
        case 2:
            [self openPicStuff];
            [tmp setSelectedSegmentIndex:0];
            drawText = NO;
            break;
        default:
            break;
    }
}

-(void)btnUndo_Clicked:(id)sender {
    LOG_METHOD
    DLog(@"dictPaths count = %d, pic counter = %d", [dictPaths count], pc);

    pc--;
    if (pc < 0) {
        tmpImgVw.image = nil;
        pc = -1;
    } else {
//        NSMutableArray *tmpPaths = [NSMutableArray arrayWithArray:_arrPaths];
        [self drawHistory];
    }
}

-(void)btnRedo_Clicked:(id)sender {
    if (pc == [dictPaths count]) {
        return;
    } else {
        pc++;
        
        [self drawHistory];
    }
}

-(void)btnColor_Clicked:(id)sender {
    LOG_METHOD
//    if (!colorPickerVisible) {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.5];
//        colorPicker.frame = CGRectOffset(colorPicker.frame, 0, -300);
//        [UIView commitAnimations];
//        colorPickerVisible = YES;
//    }

    
        const float kColorWidth = 28;
        const float kColorHeight = 28;
        const int kPadding = 2;
        
        
        if(!_colorView.subviews.count)
        {
            NSArray *colorlist = [NSArray arrayWithObjects:
                                  [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0],
                                  [UIColor colorWithRed:0.0/255.0 green:115.0/255.0 blue:0.0/255.0 alpha:1.0],
                                  [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:1.0],
                                  [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                                  [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0],
                                   nil];
            
            
            
            
            for(int i=0; i<colorlist.count; i++)
            {
                UIButton *btnRed = [[UIButton alloc] initWithFrame:CGRectMake((kColorWidth + kPadding) * i, 0, kColorWidth, kColorHeight)];
                [btnRed setBackgroundColor:[colorlist objectAtIndex:i]];
                [btnRed addTarget:self action:@selector(btnColor_Picked:) forControlEvents:UIControlEventTouchUpInside];
                [btnRed setShowsTouchWhenHighlighted:TRUE];
                [_colorView addSubview:btnRed];
            }
            

        }
        
        
        _colorButton.hidden = TRUE;
        _widthButton.hidden = FALSE;
        _widthSlider.hidden = TRUE;
        _colorView.hidden = FALSE;
        
}


-(void)btnWidth_Clicked:(id)sender
{
    _colorButton.hidden = FALSE;
    _widthButton.hidden = TRUE;
    _widthSlider.hidden = FALSE;
    _colorView.hidden = TRUE;
}




-(void)btnColor_Picked:(id)sender {
    UIButton *tmpbutton = (UIButton *)sender;
    DLog(@"Button-Tag %d, SuperView %@", tmpbutton.tag, tmpbutton.superview);
    /*
    switch (tmpbutton.tag) {
        case 9100:
            red = 1.0;
            green = 0.0;
            blue = 0.0;
            break;
        case 9010:
            red = 0.0;
            green = 1.0;
            blue = 0.0;
            break; 
        case 9001:
            red = 0.0;
            green = 0.0;
            blue = 1.0;
            break;   
        default:
            red = 0.0;
            green = 0.0;
            blue = 0.0;
            break;
    }
     */
    
    _colorPoint.backgroundColor = tmpbutton.backgroundColor;
    const float* colors = CGColorGetComponents( tmpbutton.backgroundColor.CGColor );
    red = colors[0];
    green = colors[1];
    blue = colors[2];

    
    //[_colorButton setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:alpha]];
    
    //[_colorButton setBackgroundColor:tmpbutton.backgroundColor];
    
    //[tmpbutton.superview removeFromSuperview];
}

-(void)btnColor_Done:(id)sender {
    LOG_METHOD
        //[_colorButton setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:alpha]];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        colorPicker.frame = CGRectOffset(colorPicker.frame, 0, 300);
        [UIView commitAnimations];
    
}
-(void)drawHistory {
    DLog(@"PC = %d", pc);
    CGMutablePathRef p;
    CGFloat lRed;
    CGFloat lGreen;
    CGFloat lBlue;
    CGFloat lAlpha;
    CGFloat lRadius;
    NSString *lText;
    CGPoint lPoint;

    [self _drawBackgroundImage];        

    //[tmpImgVw setImage:bild];
    UIGraphicsBeginImageContext(tmpImgVw.frame.size);

    [tmpImgVw.image drawInRect:CGRectMake(0, 0, tmpImgVw.frame.size.width, tmpImgVw.frame.size.height)];
    for (int i = 0; i < pc; i++) {
        //            p = (CGMutablePathRef)[tmpPaths objectAtIndex:i];
        NSArray *pObj = [dictPaths objectForKey:[NSString stringWithFormat:@"%d", i]];
        lRed = [[pObj objectAtIndex:1] floatValue];
        lGreen = [[pObj objectAtIndex:2] floatValue];
        lBlue = [[pObj objectAtIndex:3] floatValue];
        lAlpha = [[pObj objectAtIndex:4] floatValue];
        lRadius = [[pObj objectAtIndex:5] floatValue];
        if ([[pObj objectAtIndex:0] isKindOfClass:[NSString class]]) {
            lText = [pObj objectAtIndex:0];
            lPoint = CGPointMake([[[pObj objectAtIndex:6] objectAtIndex:0] floatValue], [[[pObj objectAtIndex:6] objectAtIndex:1] floatValue]);
            [[UIColor colorWithRed:lRed green:lGreen blue:lBlue alpha:lAlpha] set];
            [lText drawAtPoint:lPoint withFont:overlayFont];
        } else {
            p = (__bridge CGMutablePathRef)[pObj objectAtIndex:0];
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), lRed, lGreen, lBlue, lAlpha);
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lRadius);
            CGContextAddPath(UIGraphicsGetCurrentContext(), p);
            CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathStroke);
        }
        
        
        
    }
    tmpImgVw.image = UIGraphicsGetImageFromCurrentImageContext();
    //        [tmpPaths removeLastObject];
    
    UIGraphicsEndImageContext();
}

-(void)slider_EventDragStop:(id)sender {
    
    //[_colorButton setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:alpha]];
}

-(void)sliderRed_EventValueChanged:(id)sender {
    UISlider *tmpSlider = (UISlider *)sender;
    red = tmpSlider.value;
}

-(void)sliderGreen_EventValueChanged:(id)sender {
    UISlider *tmpSlider = (UISlider *)sender;
    green = tmpSlider.value;
}

-(void)sliderBlue_EventValueChanged:(id)sender {
    UISlider *tmpSlider = (UISlider *)sender;
    blue = tmpSlider.value;
}

-(void)sliderAlpha_EventValueChanged:(id)sender {
    UISlider *tmpSlider = (UISlider *)sender;
    alpha = tmpSlider.value;
}

-(void)textButton_Clicked:(id)sender {
//    [sender setBackgroundColor:[UIColor blueColor]];
    drawText = YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (canvas2Top) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        tmpImgVw.frame = self.view.bounds;
        [UIView commitAnimations];
        canvas2Top = NO;
        vOffset = 0.0;
    }
    overlayText = textField.text;
    [self drawString:textField.text atPoint:lastPoint];
    NSNumber *nRed = [NSNumber numberWithFloat:red];
    NSNumber *nGreen = [NSNumber numberWithFloat:green];
    NSNumber *nBlue = [NSNumber numberWithFloat:blue];
    NSNumber *nAlpha = [NSNumber numberWithFloat:alpha];
    NSNumber *nRadius = [NSNumber numberWithFloat:_radius];
    NSNumber *lX = [NSNumber numberWithFloat:lastPoint.x];
    NSNumber *lY = [NSNumber numberWithFloat:lastPoint.y];
    NSArray *point = [NSArray arrayWithObjects:lX, lY, nil];
    NSArray *pathObject = [NSArray arrayWithObjects:textField.text, nRed, nGreen, nBlue, nAlpha, nRadius, point, nil];
    [dictPaths setObject:pathObject forKey:[NSString stringWithFormat:@"%d", pc]];
    [textField removeFromSuperview];
    [textButton setBackgroundColor:[UIColor clearColor]];
    tfOverlayText = nil;
    overlayText = @"";
    pc++;
    return NO;
}

-(void)drawString:(NSString *)value atPoint:(CGPoint)punkt  {
    UIGraphicsBeginImageContext(self.view.frame.size);
    [tmpImgVw.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _radius);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, alpha);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);

    //    [[UIColor blackColor] set];
    //    [chartColor set];
//    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1, -1);
//    CGSize size = [value sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE]];
//    if (m<0)
//        m -= size.height;
//    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -size.width/2, -2*punkt.y+m);            
//    punkt.y -= 3;
//    punkt.y *= 0.9;
    [[UIColor colorWithRed:red green:green blue:blue alpha:alpha] set];
    [value drawAtPoint:punkt withFont:overlayFont];
    tmpImgVw.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


#pragma mark - ActionSheet Events

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    DLog(@"ActionSheetButtonIndex %d", buttonIndex);
    switch (buttonIndex) {
        case 0:
            DLog(@"Kamera");
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1:
            DLog(@"Album");
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            break;
        case 2:
            DLog(@"Gespeicherte");
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
            break;
        default:
            DLog(@"Cancel");
            return;
            break;
    }
//    [self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Touch Events

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSLog(@"touch.tapCount %d", touch.tapCount);
    CGPoint p = [touch locationInView:tmpImgVw];
    _lblTopAnzeige.text = [NSString stringWithFormat:@"%d", [touch tapCount]];
    mouseSwiped = NO;
    lastPoint = p;
//    lastPoint.y -= 15;
//    lastPoint.y *= KORREKTURFAKTORY;
    path = CGPathCreateMutable();
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    LOG_METHOD
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    NSLog(@"touch.tapCount %d", touch.tapCount);
    if(touch.tapCount > 1)
        return;
    CGPoint currentPoint = [touch locationInView:tmpImgVw];
    _lblTopAnzeige.text = [NSString stringWithFormat:@"%.0f/%.0f", currentPoint.x, currentPoint.y];
//    currentPoint.y -= 15;
//    currentPoint.y *= KORREKTURFAKTORY;
    if (!drawText) {
        UIGraphicsBeginImageContext(tmpImgVw.frame.size);
        [tmpImgVw.image drawInRect:CGRectMake(0, 0, tmpImgVw.frame.size.width, tmpImgVw.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _radius);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, alpha);
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        
        CGPathMoveToPoint(path, NULL,lastPoint.x, lastPoint.y);
        
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        
        CGPathAddLineToPoint(path, NULL, currentPoint.x, currentPoint.y);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        
        tmpImgVw.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        lastPoint = currentPoint;
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    _lblTopAnzeige.text = @"";
    
    /*
     UITouch *touch = [touches anyObject];
    if ([touch tapCount] == 2) {
        tmpImgVw.image = nil;
        pc = 0;
        return;
    }
     */
    
    if (!drawText) {
        if(!mouseSwiped) {
            UIGraphicsBeginImageContext(tmpImgVw.frame.size);
            [tmpImgVw.image drawInRect:CGRectMake(0, 0, tmpImgVw.frame.size.width, tmpImgVw.frame.size.height)];
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _radius);
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, alpha);
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            
            CGPathMoveToPoint(path, NULL,lastPoint.x, lastPoint.y);
            
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            
            CGPathAddLineToPoint(path, NULL, lastPoint.x, lastPoint.y);
            
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            //CGContextFlush(UIGraphicsGetCurrentContext());
            tmpImgVw.image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
        }
            
    //        [_arrPaths addObject:(id)path];
        NSNumber *nRed = [NSNumber numberWithFloat:red];
        NSNumber *nGreen = [NSNumber numberWithFloat:green];
        NSNumber *nBlue = [NSNumber numberWithFloat:blue];
        NSNumber *nAlpha = [NSNumber numberWithFloat:alpha];
        NSNumber *nRadius = [NSNumber numberWithFloat:_radius];
        NSArray *pathObject = [NSArray arrayWithObjects:(__bridge id)path, nRed, nGreen, nBlue, nAlpha, nRadius, nil];
        [dictPaths setObject:pathObject forKey:[NSString stringWithFormat:@"%d", pc]];
        CGPathRelease(path);
        path = CGPathCreateMutable();
        
        pc++;
    
    } else {
        if (tfOverlayText != nil) {

            [tfOverlayText removeFromSuperview];
            tfOverlayText = nil;
        }
        
        tfOverlayText = [[UITextField alloc] initWithFrame:CGRectMake(lastPoint.x, lastPoint.y, 150, 20)];
        [tfOverlayText setBackgroundColor:[UIColor clearColor]];
        tfOverlayText.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        tfOverlayText.delegate = self;
        [tfOverlayText setBorderStyle:UITextBorderStyleLine];
        [tmpImgVw addSubview:tfOverlayText];
        [tfOverlayText becomeFirstResponder];
        overlayFont = tfOverlayText.font;
        if (lastPoint.y > 160.0) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            vOffset = 160.0-lastPoint.y;
            tmpImgVw.frame = CGRectOffset(tmpImgVw.frame, 0, vOffset);
            [UIView commitAnimations];
            canvas2Top = YES;
        }
    }
    
    
//    lastPC++;

    for (int j=pc; j<[dictPaths count]; j++) {
        [dictPaths removeObjectForKey:[NSString stringWithFormat:@"%d", j]];
    }
    DLog(@"dictPaths : %@", dictPaths);
 
}

#pragma mark - UIImagePicker Events


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    //bool rotate = false;
    //if (lpicker.sourceType == UIImagePickerControllerSourceTypeCamera)
    //{
    //    need2turn = YES;
    //    rotate = TRUE;
    //}
    if (image != nil) {
        /*
         UIImage *tmpImg = [[UIImage alloc] initWithCGImage:image.CGImage];
         
         if(rotate)
         bild = [tmpImg rotate:UIImageOrientationRight];
         else
         bild = tmpImg; 
         */
        
        bild = image;
        
        [self _drawBackgroundImage];        
        
        
        
        
        
        [dictPaths removeAllObjects];
        pc = 0;
    }
    [self.view bringSubviewToFront:tBar];
//    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}





#pragma mark -
#pragma mark - Private Methods


- (void) _drawBackgroundImage
{
    
    //[tmpImgVw setImage:bild];
    
    //NSLog(@"size = %.0f / %.0f",image.size.width,image.size.height);
    
    
    
    CGSize imageSize = bild.size;
    CGSize canvasSize = tmpImgVw.frame.size; //self.view.frame.size; //tmpImgVw.frame.size;
    CGSize drawingSize;
    
    float faktorH = imageSize.height / canvasSize.height;
    float faktorW = imageSize.width / canvasSize.width;
    
    //NSLog(@" %f / %f",faktorW, faktorH);
    
    if(faktorH > faktorW)
    {
        //NSLog(@"AAAA");
        drawingSize.height = canvasSize.height;
        drawingSize.width = drawingSize.height * (imageSize.width/imageSize.height);
    }
    else
    {
        //NSLog(@"BBBB");
        drawingSize.width = canvasSize.width;
        drawingSize.height = drawingSize.width * (imageSize.height/imageSize.width);
    }
    
    
    //NSLog(@"imagesize = %.0f / %.0f",imageSize.width,imageSize.height);
    //NSLog(@"canvasSize = %.0f / %.0f",canvasSize.width,canvasSize.height);
    //NSLog(@"drawingSize = %.0f / %.0f",drawingSize.width,drawingSize.height);
    
    
    
    UIGraphicsBeginImageContext(tmpImgVw.frame.size);
    
    float offsetY = 0;
    
    [bild drawInRect:CGRectMake((tmpImgVw.frame.size.width-drawingSize.width)/2, offsetY+(tmpImgVw.frame.size.height-drawingSize.height)/2, drawingSize.width, drawingSize.height)];
    //[bild drawInRect:CGRectMake(0,0, drawingSize.width, drawingSize.height)];
    
    tmpImgVw.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

}






#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"index = %d",buttonIndex);

    if(alertView == cancelAlertView)
    {
        if(buttonIndex == 1)
        {
            [_delegate OnSketchADDRAWViewControllerCancel:self];
        }
    }
    
    
    
}






#pragma mark -
#pragma mark - Math + Helper

static inline double radians (double degrees) {return degrees * M_PI/180;}

-(UIImage *)rotate:(UIImage *)src withDegrees:(double)degrees
{
    UIImage *retImage;
    UIGraphicsBeginImageContext(src.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextRotateCTM (context, radians(degrees));
    
//    [src drawAtPoint:CGPointMake(0, 0)];
    CGContextDrawImage(context, tmpImgVw.frame, src.CGImage);
    
    retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    CGContextRelease(context);      //  @leak @sedat : Incorrect decrement of the reference of an object that is not owned at this point by caller
    return retImage;
}

@end
