//
//  ViewController.m
//  CameraDemo
//
//  Created by DBC on 16/10/9.
//  Copyright © 2016年 DBC. All rights reserved.
//

#import "ViewController.h"
#import "CameraViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)push:(id)sender {
    CameraViewController *camera = [[CameraViewController alloc] init];
    [self presentViewController:camera animated:YES completion:nil];
}

@end
