//
//  LyricsViewController.m
//  MusicPlayer
//
//  Created by FunctionMaker on 2016/12/9.
//  Copyright © 2016年 FunctionMaker. All rights reserved.
//

#import "LyricsViewController.h"
#import "LyricLines.h"
#import "LyricCell.h"

@interface LyricsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UITableView *lyricsView;

@property (strong, nonatomic) NSMutableArray<LyricLines *> *lyricLines;

@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation LyricsViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.iconView];
    [self.view addSubview:self.lyricsView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.iconView.frame = self.view.bounds;
    self.lyricsView.frame = self.view.bounds;
    self.lyricsView.contentInset = UIEdgeInsetsMake(self.view.bounds.size.height / 2, 0, self.view.bounds.size.height / 2, 0);
}

#pragma mark - Table View DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lyricLines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyricCell *cell = [tableView dequeueReusableCellWithIdentifier:[LyricCell reuseID]];
    cell.lyricLine = self.lyricLines[indexPath.row];
    
    if (indexPath.row == _currentIndex) {
        cell.shouldGradient = YES;
    } else {
        cell.shouldGradient = NO;
    }
    
    return cell;
}


#pragma mark - getters and setters

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"28131977_1383101943208"]];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.clipsToBounds = YES;
    }
    
    return _iconView;
}

- (UITableView *)lyricsView {
    if (!_lyricsView) {
        _lyricsView = [[UITableView alloc] init];
        _lyricsView.delegate = self;
        _lyricsView.dataSource = self;
        _lyricsView.showsHorizontalScrollIndicator = NO;
        _lyricsView.showsVerticalScrollIndicator = NO;
        _lyricsView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _lyricsView.backgroundColor = [UIColor clearColor];
        
        [_lyricsView registerClass:[LyricCell class] forCellReuseIdentifier:[LyricCell reuseID]];
    }
    
    return _lyricsView;
}

- (NSMutableArray<LyricLines *> *)lyricLines {
    if (!_lyricLines) {
        _lyricLines = [LyricLines lyricLinesWithFileName:_fileName];
    }
    
    return _lyricLines;
}

- (void)setFileName:(NSString *)fileName {
    if ([_fileName isEqualToString:fileName]) {
        return;
    }
    
    _fileName = fileName;
    
    [self.lyricLines removeAllObjects];
    self.lyricLines = nil;
    
    [self.lyricsView reloadData];
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    //when play next or previous song, set _currentIndex is equal to 0
    if (_currentTime > currentTime) {
        _currentIndex = 0;
    }
    
    _currentTime = currentTime;
    
    for (NSInteger i = _currentIndex; i < self.lyricLines.count; i ++) {
        LyricLines *currentLine = self.lyricLines[i];
        
        CGFloat currentLineTime = currentLine.time;
        CGFloat nextLineTime = 0;
        
        if (i + 1 < self.lyricLines.count) {
            LyricLines *nextLine = self.lyricLines[i + 1];
            nextLineTime = nextLine.time;
            
            if (currentTime >= currentLineTime && currentTime <= nextLineTime && _currentIndex != i) {
                NSArray *reloadLines = @[[NSIndexPath indexPathForRow:_currentIndex inSection:0], [NSIndexPath indexPathForRow:i inSection:0]];
                
                _currentIndex = i;
                
                [self.lyricsView reloadRowsAtIndexPaths:reloadLines withRowAnimation:UITableViewRowAnimationFade];
                [self.lyricsView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
                break;
            }
        }
    }
}

@end
