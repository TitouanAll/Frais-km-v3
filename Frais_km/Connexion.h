//
//  Connexion.h
//  Frais_km
//
//  Created by Titouan on 29/04/2016.
//  Copyright © 2016 Titouan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface Connexion : UIViewController {

NSMutableData *receivedData;
    
}

@property (strong, nonatomic) IBOutlet UITextField *ndc;

@property (strong, nonatomic) IBOutlet UITextField *mdp;

- (IBAction)Connection:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *connexionbutton;

@property (strong, nonatomic) NSString *identifiant;


@end
