//
//  MusicViewController.m
//  MusicPlayer
//
//  Created by FunctionMaker on 2016/11/2.
//  Copyright © 2016年 FunctionMaker. All rights reserved.
//

#import "MusicViewController.h"
#import "MusicTool.h"
#import "MusicCell.h"
#import "Music.h"
#import "PlayingViewController.h"

@interface MusicViewController ()<MusicSwithDelegate>

@property (nonatomic, strong) PlayingViewController *playingVC;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"音乐播放器";
    [self.tableView registerClass:[MusicCell class] forCellReuseIdentifier:[MusicCell reuseID]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [MusicTool musics].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:[MusicCell reuseID] forIndexPath:indexPath];
    cell.music = [MusicTool musics][indexPath.row];
    cell.music.delegate = self;
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MusicTool setPlayingMusic:[MusicTool musics][indexPath.row]];
    
    Music *preMusic = [MusicTool musics][_currentIndex];
    preMusic.playing = NO;
    
    Music *currentMusic = [MusicTool musics][indexPath.row];
    currentMusic.playing = YES;
    
    [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_currentIndex inSection:0], indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    _currentIndex = indexPath.row;
    
    [self presentViewController:self.playingVC animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

#pragma mark - Music Switch Delegate

- (void)switchMusicWithCurrentIndex:(NSInteger)currentIndex DestinedIndex:(NSInteger)destinedIndex {
    _currentIndex = destinedIndex;
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:currentIndex inSection:0], [NSIndexPath indexPathForRow:destinedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - getter

- (PlayingViewController *)playingVC {
    if (!_playingVC) {
        _playingVC = [[PlayingViewController alloc] initWithNibName:@"PlayingViewController" bundle:nil];
    }
    
    return _playingVC;
}

@end
