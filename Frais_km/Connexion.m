//
//  Connexion.m
//  Frais_km
//
//  Created by Titouan on 29/04/2016.
//  Copyright © 2016 Titouan. All rights reserved.
//


#import "AppDelegate.h"
#import "Connexion.h"
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface Connexion ()

@end

@implementation Connexion

extern NSString *globalString;



- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    NSLog(@"%@", globalString);
    
    _connexionbutton.layer.cornerRadius = 5;
    _hors_connexion = false;
    
    
    
    
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    
    _mdp.text = @"";
    _hors_connexion = false;
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)Connection:(id)sender {
    
   @try {
        NSString *postString = [NSString stringWithFormat:@"type="];
        NSString *urlString = [NSString stringWithFormat:@"http://%@service_connexion.php?username=%@&password=%@",globalString, _ndc.text, _mdp.text];
        
        NSLog(@" URL : %@", urlString);
        
        NSString *returnData =  [self post:postString url:urlString];
        _identifiant = returnData;
        
        NSLog(@"voi voi : %@", returnData);
        
        if ([returnData isEqualToString:@"0"] || [returnData isEqualToString:@""]) {
            NSLog(@"Connexion refusé");
            _mdp.text = @"";
            [self shakeView:self.view];
        }
        else{
            NSLog(@"Connexion réussi");
            
            [self performSegueWithIdentifier:@"connexion" sender:sender];
        }
   }
   @catch (NSException * e) {
      
       
       NSLog(@"%@",e);
       NSString *message = [NSString stringWithFormat:@"Vérifiez votre accès internet"];
       
       UIAlertController * alert=   [UIAlertController
                                     alertControllerWithTitle:@"Aucune connection"
                                     message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
       
                                       
       
       UIAlertAction* noButton = [UIAlertAction
                                  actionWithTitle:@"Ok"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      //Handel no, thanks button
                                      
                                  }];
       
       [alert addAction:noButton];
       
       [self presentViewController:alert animated:YES completion:nil];
   }


    

}

-(NSString *)post:(NSString *)postString url:(NSString*)urlString{
    
    //Response data object
    NSData *returnData = [[NSData alloc]init];
    
    //Build the Request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postString length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Send the Request
    returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    
    //Get the Result of Request
    NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
    
    bool debug = YES;
    
    if (debug && response) {
        NSLog(@"%@",response);
    }
    
    
    return response;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"connexion"]) {
        
        ViewController *vc = [segue destinationViewController];
        vc.identifiant = _identifiant;
        vc.hors_connexion = _hors_connexion;
    }
}

- (void)shakeView:(UIView *)viewToShake
{
    CGFloat t = 2.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}



- (IBAction)HC:(id)sender {
    
    _hors_connexion = true;
    [self performSegueWithIdentifier:@"connexion" sender:sender];
    
}
@end
