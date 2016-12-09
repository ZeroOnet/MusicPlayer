//
//  PlayingViewController.m
//  MusicPlayer
//
//  Created by FunctionMaker on 2016/11/4.
//  Copyright © 2016年 FunctionMaker. All rights reserved.
//

#import "PlayingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIViewExtension.h"
#import "Music.h"
#import "MusicTool.h"
#import "AudioManager.h"
#import "LyricsViewController.h"
#import "TimeConvertTool.h"

@interface PlayingViewController () <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *musicPlayer;

@property (strong, nonatomic) Music *playingMusic;

@property (strong, nonatomic) LyricsViewController *lyricsVC;

@property (strong, nonatomic) NSTimer *progressTimer;

@property (strong, nonatomic) CADisplayLink *lyricsTimer;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
@property (weak, nonatomic) IBOutlet UIButton *showLyricsBtn;

@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;

@property (weak, nonatomic) IBOutlet UIButton *showProgressLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *progressView;

@property (weak, nonatomic) IBOutlet UIButton *slider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;

@end

@implementation PlayingViewController

+ (void)initialize {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_playingMusic != [MusicTool playingMusic] && _playingMusic) {
        [self resetPlayingMusic];
    }
    
    [self startPlayingMusic];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeCurrentTimer];
    [self removeLyricsTimer];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.lyricsVC.view.frame = CGRectMake(0, 0, _topView.width, _topView.height - 50);
}

#pragma mark - Music Control

- (void)resetPlayingMusic {
    _iconView.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    _singerLabel.text = nil;
    _songLabel.text = nil;
    _timeLabel.text = [TimeConvertTool timeNormalStringWithTime:0];
    
    _slider.x = 0;
    _progressView.width = _slider.center.x;
    
    [_slider setTitle:[TimeConvertTool timeNormalStringWithTime:0] forState:UIControlStateNormal];
    
    [[AudioManager defaultManager] stopMusic];
    _musicPlayer = nil;
    
    self.lyricsVC.fileName = @"";
    self.lyricsVC.currentTime = 0;
    
    [self removeCurrentTimer];
    [self removeLyricsTimer];
}

- (void)startPlayingMusic {
    if (_playingMusic == [MusicTool playingMusic]) {
        [self addCurrentTimer];
        [self addLyricsTimer];
        
        return;
    }
    
    _playingMusic = [MusicTool playingMusic];
    _iconView.image = [UIImage imageNamed:_playingMusic.icon];
    _songLabel.text = _playingMusic.name;
    _singerLabel.text = _playingMusic.singer;
    
    _musicPlayer = [[AudioManager defaultManager] playingMusic:_playingMusic.filename];
    _musicPlayer.delegate = self;
    
    _timeLabel.text = [TimeConvertTool timeNormalStringWithTime:_musicPlayer.duration];
    
    [self addCurrentTimer];
    [self addLyricsTimer];
    
    self.lyricsVC.fileName = _playingMusic.lrcname;
    
    _playOrPauseBtn.selected = YES;
    
    [self updateLockedScreenMusic];
}

#pragma mark - Timer Control

- (void)addCurrentTimer {
    if (!_musicPlayer.isPlaying) {
        return;
    }
    
    [self removeCurrentTimer];
    [self updateCurrentTimer];
    
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCurrentTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeCurrentTimer {
    [_progressTimer invalidate];
    _progressTimer = nil;
}

- (void)updateCurrentTimer {
    double timeRate = _musicPlayer.currentTime / _musicPlayer.duration;
    
    _slider.x = timeRate * (self.view.width - _slider.width);
    [_slider setTitle:[TimeConvertTool timeNormalStringWithTime:_musicPlayer.currentTime] forState:UIControlStateNormal];
    _progressView.width = _slider.center.x;
}

- (void)addLyricsTimer {
    if (![_topView.subviews containsObject:self.lyricsVC.view]) {
        return;
    }
    
    if (_musicPlayer.isPlaying == NO && _lyricsTimer) {
        [self updateLyricsTimer];
        
        return;
    }
    
    [self removeLyricsTimer];
    [self updateLyricsTimer];
    
    //the frequence of update is in line with updating Screen(f = 60HZ)
    _lyricsTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLyricsTimer)];

    [_lyricsTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeLyricsTimer {
    [_lyricsTimer invalidate];
    _lyricsTimer = nil;
}

- (void)updateLyricsTimer {
    self.lyricsVC.currentTime = _musicPlayer.currentTime;
}

#pragma mark - Remove Serve

- (void)updateLockedScreenMusic {
    NSMutableDictionary *MPInfo = [NSMutableDictionary dictionary];
    MPInfo[MPMediaItemPropertyAlbumTitle] = _playingMusic.name;
    MPInfo[MPMediaItemPropertyArtist] = _playingMusic.singer;
    MPInfo[MPMediaItemPropertyTitle] = _playingMusic.name;
    MPInfo[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:_playingMusic.icon]];
    MPInfo[MPMediaItemPropertyPlaybackDuration] = @(_musicPlayer.duration);
    MPInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(_musicPlayer.currentTime);
    
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    center.nowPlayingInfo = MPInfo;
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

#pragma mark - Remote Control Events Observer

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previousSong];
            break;
            
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [self playOrPauseSong];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            [self nextSong];
            break;
            
        default:
            break;
    }
}

#pragma mark - AVFundation Delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self nextSong];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    [self playOrPauseSong];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
    [self playOrPauseSong];
}

#pragma mark - IB Control

- (IBAction)exitPlaying:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self removeCurrentTimer];
        [self removeLyricsTimer];
    }];
}

- (IBAction)showLyrics:(UIButton *)sender {
    if (![_topView.subviews containsObject:self.lyricsVC.view]) {
        [self addChildViewController:self.lyricsVC];
        
        [_topView addSubview:self.lyricsVC.view];
        [_topView insertSubview:_exitBtn aboveSubview:self.lyricsVC.view];
        [_topView insertSubview:_showLyricsBtn aboveSubview:self.lyricsVC.view];
        
        [self addLyricsTimer];
    } else {
        [self.lyricsVC.view removeFromSuperview];
        [self.lyricsVC removeFromParentViewController];
        
        [self removeLyricsTimer];
    }
}

- (IBAction)panSlider:(UIPanGestureRecognizer *)sender {
    CGFloat maxX = self.view.width - sender.view.width;
    CGPoint point = [sender translationInView:sender.view];
    
    sender.view.x += point.x;

    if (sender.view.x < 0) {
        sender.view.x = 0;
    } else if (sender.view.x > maxX) {
        sender.view.x = maxX;
    }
    
    CGFloat time = (sender.view.x / (self.view.width - sender.view.width)) * _musicPlayer.duration;
    
    [_showProgressLabel setTitle:[TimeConvertTool timeNormalStringWithTime:time] forState:UIControlStateNormal];
    [_slider setTitle:[TimeConvertTool timeNormalStringWithTime:time] forState:UIControlStateNormal];
    
    _progressView.width = sender.view.center.x;
    _showProgressLabel.x = self.slider.x;

    if (sender.state == UIGestureRecognizerStateBegan) {
        [self removeCurrentTimer];
        [self removeLyricsTimer];
        
        _showProgressLabel.hidden = NO;
        _showProgressLabel.y = _showProgressLabel.superview.height / 2 - _showProgressLabel.height / 2;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        _musicPlayer.currentTime = time;
        _showProgressLabel.hidden = YES;

        [self addCurrentTimer];
        [self addLyricsTimer];
    }

    [sender setTranslation:CGPointZero inView:sender.view];
}

- (IBAction)tapProgressView:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:sender.view];
    
    _musicPlayer.currentTime = (point.x / sender.view.width) * _musicPlayer.duration;
    
    [self updateCurrentTimer];
    [self updateLyricsTimer];
}

- (IBAction)previousSong {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    keyWindow.userInteractionEnabled = NO;
    
    [[AudioManager defaultManager] stopMusic];
    [MusicTool setPlayingMusic:[MusicTool previousMusic]];
    [self removeCurrentTimer];
    [self removeLyricsTimer];
    [self startPlayingMusic];
    
    keyWindow.userInteractionEnabled = YES;
}

- (IBAction)playOrPauseSong {
    if (_playOrPauseBtn.isSelected == NO) {
        _playOrPauseBtn.selected = YES;
        _musicPlayer =  [[AudioManager defaultManager] playingMusic:_playingMusic.filename];
        
        [self addCurrentTimer];
        [self addLyricsTimer];
    } else {
        _playOrPauseBtn.selected = NO;
        [[AudioManager defaultManager] pauseMusic];
        
        [self removeCurrentTimer];
        [self removeLyricsTimer];
    }
}

- (IBAction)nextSong {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    keyWindow.userInteractionEnabled = NO;
    
    [[AudioManager defaultManager] stopMusic];
    [MusicTool setPlayingMusic:[MusicTool nextMusic]];
    [self removeCurrentTimer];
    [self removeLyricsTimer];
    [self startPlayingMusic];
    
    keyWindow.userInteractionEnabled = YES;
}

#pragma mark - getter

- (LyricsViewController *)lyricsVC {
    if (!_lyricsVC) {
        _lyricsVC = [[LyricsViewController alloc] init];
    }
    
    return _lyricsVC;
}

@end
