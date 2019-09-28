//
//  ScrollChatView.m
//  直播滚动聊天
//
//  Created by 许明洋 on 2019/9/28.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import "ScrollChatView.h"
#import "ScrollChatTextModel.h"

@interface ScrollChatView()<UITableViewDelegate,UITableViewDataSource>

/**
 定时器
 */
@property (nonatomic,strong) NSTimer *timer;
/**
 展示在可见table上的数据源
 */
@property (nonatomic,strong) NSMutableArray *imTableDataSource;
/**
 数据源
 */
@property (nonatomic,retain) NSMutableArray *yxDataSource;

@property (nonatomic,assign) NSInteger scrollIndex;

@end

@implementation ScrollChatView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setupUI];
        self.scrollIndex = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(action) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)action {
    
    ScrollChatTextModel *md = [self.yxDataSource objectAtIndex:arc4random()%self.dataList.count];
    [self.imTableDataSource insertObject:md atIndex:0];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];
}

- (NSMutableArray *)imTableDataSource {
    if (_imTableDataSource == nil) {
        _imTableDataSource = [NSMutableArray new];
    }
    return _imTableDataSource;
}

- (void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    _yxDataSource = [[NSMutableArray alloc] init];
    [dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *content = (NSString *)obj;
        CGSize contentSize = [self sizeWithFont:[UIFont systemFontOfSize:18] width:self.frame.size.width - 30 content:content];
        
        //判断，当我们设置了字体大小时，使用设置的字体大小，否则使用默认的18号字体大小
        if (self.font) {
            contentSize = [self sizeWithFont:self.font width:self.frame.size.width - 30 content:content];
        }
        
        ScrollChatTextModel *md = [[ScrollChatTextModel alloc] init];
        md.yx_content = content;
        md.yx_height = contentSize.height + 20;
        if (self.padding > 0) {
            md.yx_height = contentSize.height + self.padding * 2;
        }
        [_yxDataSource addObject:md];
    }];
    [self reloadData];
}

- (void)setSpeed:(NSInteger)speed {
    _speed = speed;
    [_timer setFireDate:[NSDate distantFuture]];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(action) userInfo:nil repeats:YES];
}

#pragma mark - UITableViewDataSource/UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /**
     因为每个cell中内容不同，所以大小也不相同，使用UITableView高度的估计机制
     */
    ScrollChatTextModel *md = _imTableDataSource[indexPath.row];
    return md.yx_height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imTableDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    /**
     因为没有注册cell，使用这种方法创建cell需要进行cell判别是否为空
     */
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.transform = CGAffineTransformMakeScale(1, -1);
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:18.f];
    
    ScrollChatTextModel *md = [self.imTableDataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = md.yx_content;
    if (self.font) {
        cell.textLabel.font = self.font;
    }
    if (self.color) {
        cell.textLabel.textColor = self.color;
    }
    if (self.contentColor) {
        NSRange range = [md.yx_content rangeOfString:@"："];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:md.yx_content];
        [string addAttribute:NSForegroundColorAttributeName value:self.contentColor range:NSMakeRange(0, range.location)];
        cell.textLabel.attributedText = string;
    }
    if (self.reviewerNickNameColor) {
        NSRange range = [md.yx_content rangeOfString:@"："];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:md.yx_content];
        [string addAttribute:NSForegroundColorAttributeName value:self.reviewerNickNameColor range:NSMakeRange(range.location, string.length - range.location)];
        cell.textLabel.attributedText = string;
    }
    
    //如果是偶数行
    if (self.scrollIndex % 2 == 0) {
        
        if (self.evenNumberContentColor) {
            NSRange range = [md.yx_content rangeOfString:@"："];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:md.yx_content];
            [string addAttribute:NSForegroundColorAttributeName value:self.evenNumberContentColor range:NSMakeRange(range.location, string.length - range.location)];
            cell.textLabel.attributedText = string;
        }
        
        if (self.evenNumberNickNameColor) {
            NSRange range = [md.yx_content rangeOfString:@"："];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:md.yx_content];
            [string addAttribute:NSForegroundColorAttributeName value:self.evenNumberNickNameColor range:NSMakeRange(0, range.location)];
            cell.textLabel.attributedText = string;
        }
    } else {
        if (self.oddNumberContentColor) {
            NSRange range = [md.yx_content rangeOfString:@"："];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:md.yx_content];
            [string addAttribute:NSForegroundColorAttributeName value:self.oddNumberContentColor range:NSMakeRange(0, range.location)];
            cell.textLabel.attributedText = string;
        }
        if (self.oddNumberNickNameColor) {
            NSRange range = [md.yx_content rangeOfString:@"："];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:md.yx_content];
            [string addAttribute:NSForegroundColorAttributeName value:self.oddNumberNickNameColor range:NSMakeRange(0, range.location)];
            cell.textLabel.attributedText = string;
        }
    }
    self.scrollIndex++;
    return cell;
    
}

//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ScrollChatTextModel *md = _imTableDataSource[indexPath.row];
//这一部分是协议的回调，将其改为block传值
    //    if (self.yx_delegate && [self.yx_delegate respondsToSelector:@selector(ScrollViewChatTextView:withIdex:withText:)]) {
//        [self.yx_delegate ScrollViewChatTextView:self withIdex:indexPath.row withText:md.yx_content];
//    }
    //调用这个方法
    self.showContentBlock(self, indexPath.row,md.yx_content);
}


//这个方法的作用目前还没发现
- (void)setCurrentText:(NSString *)currentText {
    _currentText = currentText;
    [_timer setFireDate:[NSDate distantFuture]];
    [self.imTableDataSource insertObject:currentText atIndex:0];
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];
    
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)setupUI {
    
    self.delegate = self;
    self.dataSource = self;
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    self.separatorColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableHeaderView = [[UIView alloc] init];
    self.transform = CGAffineTransformMakeScale(1, -1);
    
    
}

//获取评论内容的大小
- (CGSize)sizeWithFont:(UIFont *)font width:(CGFloat)width content:(NSString *)content {
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    return [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
