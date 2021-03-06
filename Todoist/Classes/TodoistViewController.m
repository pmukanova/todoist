//
//  TodoistViewController.m
//  Todoist
//
//  Created by Chris Hudson on 23/07/2010.
//  Copyright (c) 2010 Xetius Software. All rights reserved.
//

#import "TodoistViewController.h"
#import "ProjectsTableViewController.h"
#import "ItemsTableViewController.h"

@implementation TodoistViewController

@synthesize projectId;
@synthesize flipTableButton;
@synthesize projectsTableViewController;
@synthesize itemsTableViewController;
@synthesize frontVisible;

-(id)initWithProjectId:(NSInteger)pId {
	self.projectId = pId;
	return [super initWithNibName:@"TodoistViewController" bundle:nil];
}

-(id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
	self.projectId = 0;
	return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

-(void)pushViewController:(CONTROLLERTYPE)controllerType projectId:(NSInteger)pId {
	TodoistViewController* newViewController = [[TodoistViewController alloc] initWithProjectId:pId];
	[self.navigationController pushViewController:newViewController animated:YES];
	[newViewController release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
	// Add flippable button to the nav bar
	UIButton* localFlipButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
	self.flipTableButton = localFlipButton;
	[localFlipButton release];
	
	[self.flipTableButton setBackgroundImage:[UIImage imageNamed:@"items-bar-button.png"] forState:UIControlStateNormal];
	UIBarButtonItem* flipButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.flipTableButton];
	[self.navigationItem setRightBarButtonItem:flipButtonItem animated:YES];
	
	self.frontVisible = YES;
	
    self.projectsTableViewController = [[ProjectsTableViewController alloc] initWithNibName:@"ProjectsTableViewController" bundle:nil];
	self.projectsTableViewController.parentViewController = self;
	self.projectsTableViewController.projectId = self.projectId;
	[self.view addSubview:self.projectsTableViewController.view];
	
	self.itemsTableViewController = [[ItemsTableViewController alloc] initWithNibName:@"ItemsTableViewController" bundle:nil];
	self.itemsTableViewController.parentViewController = self;
	self.itemsTableViewController.projectId = self.projectId;
	
	[self.flipTableButton addTarget:self action:@selector(flipCurrentView) forControlEvents:UIControlEventTouchDown];
	
	self.title = @"Projects";
}

-(void)flipCurrentView {

	self.frontVisible = !self.frontVisible;

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(myTransitionDidStop:finished:context:)];
	if (self.frontVisible) {
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
		[itemsTableViewController.view removeFromSuperview];
		[self.view addSubview:projectsTableViewController.view];	
	}
	else {
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
		[projectsTableViewController.view removeFromSuperview];
		[self.view addSubview:itemsTableViewController.view];
	}
	[UIView commitAnimations];

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(myTransitionDidStop:finished:context:)];
	if (self.frontVisible) {
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:flipTableButton cache:YES];
		[self.flipTableButton setBackgroundImage:[UIImage imageNamed:@"items-bar-button.png"] forState:UIControlStateNormal];
	}
	else {
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:flipTableButton cache:YES];
		[self.flipTableButton setBackgroundImage:[UIImage imageNamed:@"projects-bar-button.png"] forState:UIControlStateNormal];		
	}
	[UIView commitAnimations];
	
	if (self.frontVisible) {
		self.title = @"Projects";
	}
	else
	{
		self.title = @"Items";
	}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
