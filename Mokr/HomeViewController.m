//
//  ViewController.m
//  Mokr
//
//  Created by Jernej Virag on 8/9/11.
//  Copyright (c) 2011 Jernej Virag. All rights reserved.
//

#import "HomeViewController.h"
#import "LocationsViewController.h"

@implementation HomeViewController

// Properties
@synthesize scrollView, scrollPageControl, infoButton;
@synthesize selectedLocations;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        SelectedLocationsController *selectedLocationsController = [[SelectedLocationsController alloc] init];
        [self setSelectedLocations:selectedLocationsController];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (UIView*)createLocationView:(int)viewIndex
{
    UIView *locationView = [[UIView alloc] initWithFrame:CGRectMake(viewIndex * 320, 0, 320, 400)];
    UIView *innerView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 280, 400)];
    [locationView addSubview:innerView];
    [innerView setBackgroundColor:[UIColor blueColor]];
     
    return locationView;
}

- (void)createLocationViews:(UIScrollView*)scroll
{
    locationViews = [[NSMutableArray alloc] init];
    
    // Create location views, current location first
    [scroll setContentSize:CGSizeMake(320 * ([selectedLocations.selectedLocations count] + 1), 420)];
    UIView *locationView = [self createLocationView:0];
    [scroll addSubview:locationView];
    [locationViews addObject:locationView];
    
    int i = 1;
    
    // Create the rest
    for (Location* location in selectedLocations.selectedLocations)
    {
        UIView *viewForLocation = [self createLocationView:i];
        [scroll addSubview:viewForLocation];
        [locationViews addObject:locationView];
        i++;
    }
    
    [scrollPageControl setNumberOfPages:i];
}

// Create main application views
- (void)loadView
{
    UIView *main = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    // Attach main view to application
    [self setView:main];
    
    // Create scrollview to span application
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    [scroll setPagingEnabled:YES];
    [scroll setShowsHorizontalScrollIndicator:NO];
    [scroll setShowsVerticalScrollIndicator:NO];
    [scroll setScrollsToTop:NO];
    [scroll setDelegate:self];
    [self setScrollView: scroll];
    [main addSubview:scroll];
    
    // Create page control for scrollview
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 410, 320, 44)];
    [pageControl setDefersCurrentPageDisplay:YES];
    [main addSubview:pageControl];
    [self setScrollPageControl:pageControl];

    // Create subviews for the scroller
    [self createLocationViews:scroll];
        
    // Create info button to add location
    UIButton *info = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [info setFrame:CGRectMake(280, 420, 20, 20)];
    [info addTarget:self action:@selector(showAddLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self setInfoButton:info];
    [main addSubview:info];
}

- (void)showAddLocation:(id)sender
{
    __block id me = self;
    LocationsViewController *locations = [[LocationsViewController alloc] initWithAction:^(void){
        // Remove all scrollviews
        for (UIView *view in [scrollView subviews])
            [view removeFromSuperview];
        
        [selectedLocations loadFromDefaults];
        [self createLocationViews:scrollView];
        
        [me dismissModalViewControllerAnimated:YES]; 
    }];
    [locations setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentModalViewController:locations animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView                                          
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [scrollPageControl setCurrentPage:page];
    [scrollPageControl updateCurrentPageDisplay];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
