//
//  MeetUpsViewController.m
//  MeetMeUp
//
//  Created by Nader Neyzi on 1/15/16.
//  Copyright © 2016 Nader Neyzi. All rights reserved.
//

#import "EventsViewController.h"

@interface EventsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *results;

@end

@implementation MeetUpsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self getMeetups];


}

- (void)getMeetups {

    NSURL *url = [NSURL URLWithString:@"https://api.meetup.com/2/open_events.json?zip=95050&text=mobile&time=,1w&key=353a15723f7867175a2a7b88461e"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (error.code != -999) {
                NSLog(@"%@", error);
            }
        } else {
            NSDictionary *events = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.results = [events objectForKey:@"results"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];

            });
        }
    }];
    [task resume];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    NSDictionary *event = [self.results objectAtIndex:indexPath.row];
    cell.textLabel.text = [event objectForKey:@"name"];
    NSDictionary *venue = [event objectForKey:@"venue"];
    cell.detailTextLabel.text = [venue objectForKey:@"address_1"];
    return cell;
}



@end
