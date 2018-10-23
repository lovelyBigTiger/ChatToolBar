//
//  ViewController.m
//  ChatBarDemo
//
//  Created by wyl on 2018/10/23.
//  Copyright © 2018年 wyl. All rights reserved.
//

#import "ViewController.h"
#import "ZYChatInputToolBar.h"

@interface ViewController ()<ZYChatInputToolBarDelegate>

@property (nonatomic, strong) ZYChatInputToolBar *inputToolBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _inputToolBar = [[ZYChatInputToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    _inputToolBar.delegate = self;
    [self.view addSubview:_inputToolBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.inputToolBar supperViewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.inputToolBar superViewWillDisappear];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.inputToolBar resignFirstResponder];
}

- (void)inputToolBar:(ZYChatInputToolBar *)toolBar didChangeY:(float)y {
    NSLog(@"--- y == %f ---", y);
    
}

@end
