//
//  ViewController.m
//  frais_km
//
//  Created by Titouan on 13/04/2016.
//  Copyright © 2016 Titouan. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>




@interface ViewController ()

@property (nonatomic,readonly) NSManagedObjectContext *Managed;

@end

@implementation ViewController

extern NSString *globalString;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _securite = false;
    
    
    _fadelabel.alpha = 0;
    
    _valide.alpha = 0;
    
    
    self.typepicker.delegate=self;
    self.typepicker.dataSource=self;
    
    _km.layer.cornerRadius = 5;
    _km.clipsToBounds = YES;
    _km.layer.borderColor = [[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.0] CGColor];
    
    
    self.carbupicker.delegate=self;
    self.carbupicker.dataSource=self;
    
    
    _resultat.layer.borderColor=[[UIColor blackColor]CGColor]; // bordur resultat
    _resultat.layer.borderWidth= 1.0f;                         // bordur resultat
    
    _deconnecter.layer.cornerRadius = 3;
    _deconnecter.layer.borderWidth= 0.5f;
    _deconnecter.layer.borderColor=[[UIColor blackColor]CGColor];
    
    _Soumettre.layer.cornerRadius = 3;
    _Soumettre.layer.borderWidth= 0.5f;
    _Soumettre.layer.borderColor=[[UIColor blackColor]CGColor];
    
    
    [_km addTarget:self
            action:@selector(myTextFieldDidChange:)
  forControlEvents:UIControlEventEditingChanged];
    
    [self Createdb];
    
    if (_hors_connexion == false) {
        
        [self GetData];
        
    }
    
    [self InsertData];
}


- (void)viewDidAppear:(BOOL)animated
{
    
    if (_hors_connexion == false) {
        
        [self GetData];
        [self InsertData];
        
    }
    
    [self.typepicker reloadAllComponents];
    [self.typepicker setNeedsLayout];
    
    [self.carbupicker reloadAllComponents];
    [self.carbupicker setNeedsLayout];
    
    NSLog(@"%@", _listetype);
    NSLog(@"%@", _listecarbu);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    if([thePickerView isEqual: _typepicker]){
        return 1;
    }
    else{
        return 1;
    }
    
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    if([thePickerView isEqual: _typepicker]){
        return [_listetype count];
    }
    else{
        return [_listecarbu count];
    }
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([thePickerView isEqual: _typepicker]){
        return [_listetype objectAtIndex:row];
    }
    else{
        return [_listecarbu objectAtIndex:row];
    }
    
}

// Picker Delegate
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    float kilometres = [_km.text floatValue];
    _resultat.text = [NSString stringWithFormat:@"%.2f",_number*kilometres];
    [UIView animateWithDuration:0.4 animations:^(void) {
        _fadelabel.alpha = 1;
        _fadelabel.alpha = 0;
    }];
    
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT PRIX FROM TARIFS T INNER JOIN PUISSANCE P ON T.IDPUISSANCE = P.ID INNER JOIN CARBURANT C ON T.IDCARBURANT = C.ID WHERE C.ID=(SELECT ID FROM CARBURANT WHERE LIBELLE='%@') AND P.ID=(SELECT ID FROM PUISSANCE WHERE LIBELLE='%@')",[self.listecarbu objectAtIndex:[self.carbupicker selectedRowInComponent:0]], [self.listetype objectAtIndex:[self.typepicker selectedRowInComponent:0]]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        sqlite3_prepare_v2(_DB, query_stmt,-1, &statement, NULL);
        
        if (sqlite3_prepare_v2(_DB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *lib = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                _number = [lib floatValue];
                float kilometres = [_km.text floatValue];
                //float result = number*kilometres;
                
                
                _taux.text = [NSString stringWithFormat:@"%.2f€/km",_number];
                
                
                
                
                _resultat.text = [NSString stringWithFormat:@"%.2f",_number*kilometres];
                
                
                
                
            }
            else {
                
                _resultat.text = @"Non défini";
                _taux.text = [NSString stringWithFormat:@""];
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_DB);
    }
    
    _securite = false;
    
}


- (void)myTextFieldDidChange:(id)sender {
    
    float kilometres = [_km.text floatValue];
    _resultat.text = [NSString stringWithFormat:@"%.2f",_number*kilometres];
    [UIView animateWithDuration:0.4 animations:^(void) {
        _fadelabel.alpha = 1;
        _fadelabel.alpha = 0;
        _securite = false;
    }];
}





- (IBAction)soumission:(id)sender {
    
    if (_hors_connexion == false)
    {
        
        NSString *idprix;
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy'-'MM'-'dd"];
        
        sqlite3_stmt    *statement;
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_DB) == SQLITE_OK)
        {
            
            NSString *querySQL = [NSString stringWithFormat:@"SELECT T.ID FROM TARIFS T INNER JOIN PUISSANCE P ON T.IDPUISSANCE = P.ID INNER JOIN CARBURANT C ON T.IDCARBURANT = C.ID WHERE C.ID=(SELECT ID FROM CARBURANT WHERE LIBELLE='%@') AND P.ID=(SELECT ID FROM PUISSANCE WHERE LIBELLE='%@')",[self.listecarbu objectAtIndex:[self.carbupicker selectedRowInComponent:0]], [self.listetype objectAtIndex:[self.typepicker selectedRowInComponent:0]]];
            
            
            
            const char *query_stmt = [querySQL UTF8String];
            
            sqlite3_prepare_v2(_DB, query_stmt,-1, &statement, NULL);
            
            if (sqlite3_prepare_v2(_DB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    idprix = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    
                }
            }
            
        }
        
        
        if ([_km.text isEqualToString:@""]) {
            
            _km.layer.borderWidth = 1.0f;
            
            [CATransaction begin]; {
                [CATransaction setCompletionBlock:^{
                    // How the textField should look at the end of the animation.
                    _km.layer.borderColor = [UIColor colorWithRed:255.0 green:0.0 blue:0.0 alpha:0.0].CGColor;
                    
                }];
                
                CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
                
                
                colorAnimation.toValue   = (__bridge id)[UIColor colorWithRed:255.0 green:0.0 blue:0.0 alpha:0].CGColor ;
                
                
                colorAnimation.fromValue = (__bridge id)[UIColor colorWithRed:255.0 green:0.0 blue:0.0 alpha:0.5].CGColor;
                
                
                colorAnimation.duration = 1.5;
                
                [_km.layer addAnimation:colorAnimation forKey:@"color"];
                
            } [CATransaction commit];
            
        }
        
        else if (_securite == true)
        {
            
            NSString *message = [NSString stringWithFormat:@"Une demande de remboursement a déja été envoyé pour un remboursement de %@ km, voulez vous l'envoyer a nouveau ?", _km.text];
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Envoyer a nouveau ?"
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Oui"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            
                                            [UIView animateWithDuration:5 animations:^(void) {
                                                
                                                _valide.alpha = 0;
                                                _valide.alpha = 0.6;
                                                _valide.alpha = 0;
                                                
                                            }];
                                            
                                            NSString *postString = [NSString stringWithFormat:@"type="];
                                            NSString *urlString = [NSString stringWithFormat:@"http://%@service_soumission.php?idvisiteur=%@&idprix=%@&km=%@&total=%.2f", globalString, _identifiant, idprix, _km.text, _number*[_km.text floatValue]];
                                            
                                            NSLog(@"URL : %@", urlString);
                                            
                                            [self post:postString url:urlString];
                                            
                                            _securite = true;
                                            
                                            
                                            
                                            
                                            
                                        }];
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"Non, annuler"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           //Handel no, thanks button
                                           
                                       }];
            
            [alert addAction:yesButton];
            [alert addAction:noButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        else {
            
            NSString *Message = [NSString stringWithFormat:@"Remboursement de %@ km",_km.text];
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:Message
                                          message:@"Voulez vous vraiment envoyer une demande de remboursement ?"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Oui"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            
                                            [UIView animateWithDuration:5 animations:^(void) {
                                                
                                                _valide.alpha = 0;
                                                _valide.alpha = 0.6;
                                                _valide.alpha = 0;
                                                
                                            }];
                                            
                                            NSString *postString = [NSString stringWithFormat:@"type="];
                                            NSString *urlString = [NSString stringWithFormat:@"http://%@service_soumission.php?idvisiteur=%@&idprix=%@&km=%@&total=%.2f", globalString, _identifiant, idprix, _km.text, _number*[_km.text floatValue]];
                                            
                                            
                                            [self post:postString url:urlString];
                                            
                                            _securite = true;
                                            
                                            
                                            
                                            
                                            
                                        }];
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"Non, annuler"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           //Handel no, thanks button
                                           
                                       }];
            
            [alert addAction:yesButton];
            [alert addAction:noButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
    }
    else{
        NSString *message = [NSString stringWithFormat:@"Veuillez vous identifier pour pouvoir soumettre une demande de remboursement"];
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Impossible en mode hors-connexion"
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





- (IBAction)deconnecter:(id)sender {
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)post:(NSString *)postString url:(NSString*)urlString{
    
    //Response data object
    NSData *returnData = [[NSData alloc]init];
    
    //Build the Request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postString length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Send the Request
    returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    
}



- (void)GetData
{
    
    
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"frais.db"]];
    
    
    const char *dbpath = [_databasePath UTF8String];
    
    @try {
        if (sqlite3_open(dbpath, &_DB) == SQLITE_OK)
        {
            
            sqlite3_stmt    *statement;
            NSString *insertversion = [NSString stringWithFormat:@"SELECT MAX(IDVERSION) FROM VERSION"];
            const char *query_version = [insertversion UTF8String];
            sqlite3_prepare_v2(_DB, query_version,-1, &statement, NULL);
            
            if (sqlite3_prepare_v2( _DB, query_version, -1, &statement, nil) == SQLITE_OK) {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    _ancienneversion = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                    
                }
            }
            
            NSString *idversion;
            idversion = @"IDVERSION";
            NSData *jsonDataVersion = [NSData dataWithContentsOfURL:
                                       [NSURL URLWithString: [NSString stringWithFormat:@"http://%@service_nouveautarif.php", globalString]]];
            id jsonObjectsNouveauTarif = [NSJSONSerialization JSONObjectWithData:jsonDataVersion options:NSJSONReadingMutableContainers error:nil];
            
            for (NSDictionary *dataDict in jsonObjectsNouveauTarif) {
                
                _version = [dataDict objectForKey:@"IDVERSION"];
                
            }
            
            NSLog(@"ancienne : %@ || nouvelle : %@",_ancienneversion, _version);
            
            if ([_ancienneversion isEqualToString: _version])
            {
                NSLog(@"Même version");
            }
            else
            {
                NSLog(@"Version différente");
                
                
                NSString *insertversion = [NSString stringWithFormat:@"INSERT INTO VERSION (IDVERSION) VALUES (%@)",_version];
                const char *version_stmt = [insertversion UTF8String];
                
                sqlite3_prepare_v2(_DB, version_stmt, -1, &statement, NULL);
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"Reussi");
                }
                
                
                
                
                
                
                //RECUPERATION TARIF
                
                
                NSMutableArray *prixtab;
                prixtab = [[NSMutableArray alloc] init];
                
                NSMutableArray *idcarbutab;
                idcarbutab = [[NSMutableArray alloc] init];
                
                NSMutableArray *idpuitab;
                idpuitab = [[NSMutableArray alloc] init];
                
                NSMutableArray *idtariftab;
                idtariftab = [[NSMutableArray alloc] init];
                
                NSDictionary *dict;
                
                NSString *prix;
                NSString *idcarbu;
                NSString *idpui;
                NSString *idtarif;
                
                
                prix = @"PRIX";
                idcarbu = @"IDCARBURANT";
                idpui = @"IDPUISSANCE";
                idtarif = @"ID";
                
                
                
                NSData *jsonDataTarif = [NSData dataWithContentsOfURL:
                                         [NSURL URLWithString: [NSString stringWithFormat:@"http://%@service_tarifs.php", globalString]]];
                
                
                id jsonObjectsTarif = [NSJSONSerialization JSONObjectWithData:jsonDataTarif options:NSJSONReadingMutableContainers error:nil];
                
                
                
                // values in foreach loop
                for (NSDictionary *dataDict in jsonObjectsTarif) {
                    NSString *strPrix = [dataDict objectForKey:@"PRIX"];
                    NSString *strIdCarbu = [dataDict objectForKey:@"IDCARBURANT"];
                    NSString *strIdPui = [dataDict objectForKey:@"IDPUISSANCE"];
                    NSString *strIdTar = [dataDict objectForKey:@"ID"];
                    
                    
                    dict = [NSDictionary dictionaryWithObjectsAndKeys:
                            strPrix, prix,
                            strIdCarbu, idcarbu,
                            strIdPui, idpui,
                            strIdTar, idtarif,
                            nil];
                    [prixtab addObject:[dict objectForKey:@"PRIX"]];
                    [idcarbutab addObject:[dict objectForKey:@"IDCARBURANT"]];
                    [idpuitab addObject:[dict objectForKey:@"IDPUISSANCE"]];
                    [idtariftab addObject:[dict objectForKey:@"ID"]];
                    
                }
                
                
                
                NSString *truncatetarifs = [NSString stringWithFormat:@"DELETE FROM TARIFS"];
                const char *truncatetarfs_stmt = [truncatetarifs UTF8String];
                
                sqlite3_prepare_v2(_DB, truncatetarfs_stmt, -1, &statement, NULL);
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"tarif truncate");
                }
                
                int i;
                
                for (i = 0; i < idpuitab.count; i++)
                {
                    NSString *inserttarif = [NSString stringWithFormat:@"INSERT INTO TARIFS (ID, IDPUISSANCE, IDCARBURANT, PRIX) VALUES (%@, %@, %@, %@)", idtariftab[i], idpuitab[i],idcarbutab[i],prixtab[i]];
                    const char *tarif_stmt = [inserttarif UTF8String];
                    
                    sqlite3_prepare_v2(_DB, tarif_stmt, -1, &statement, NULL);
                    if (sqlite3_step(statement) == SQLITE_DONE)
                    {
                        NSLog(@"%@",inserttarif);
                    }
                }
                
                //RECUPERATION TARIF
                
                
                
                
                //RECUPERATION CARBURANT
                
                
                NSMutableArray *idtabcarbu;
                idtabcarbu = [[NSMutableArray alloc] init];
                
                NSMutableArray *libtabcarbu;
                libtabcarbu = [[NSMutableArray alloc] init];
                
                NSDictionary *dictcarbu;
                
                NSString *id_carbu;
                NSString *libellecarbu;
                
                
                id_carbu = @"ID";
                libellecarbu = @"LIBELLE";
                
                
                NSData *jsonDataCarbu = [NSData dataWithContentsOfURL:
                                         [NSURL URLWithString: [NSString stringWithFormat:@"http://%@service_carburant.php",globalString]]];
                
                
                id jsonObjectCarbu = [NSJSONSerialization JSONObjectWithData:jsonDataCarbu options:NSJSONReadingMutableContainers error:nil];
                
                
                
                // values in foreach loop
                for (NSDictionary *dataDict in jsonObjectCarbu) {
                    
                    NSString *strID = [dataDict objectForKey:@"ID"];
                    NSString *strLibelle = [dataDict objectForKey:@"LIBELLE"];
                    
                    dictcarbu = [NSDictionary dictionaryWithObjectsAndKeys:
                                 strID, id_carbu,
                                 strLibelle, libellecarbu,
                                 nil];
                    [idtabcarbu addObject:[dictcarbu objectForKey:@"ID"]];
                    [libtabcarbu addObject:[dictcarbu objectForKey:@"LIBELLE"]];
                    
                    NSLog(@"Nouveau : %@",[dictcarbu objectForKey:@"LIBELLE"]);
                    
                }
                
                
                
                NSString *truncatecarbu = [NSString stringWithFormat:@"DELETE FROM CARBURANT"];
                const char *truncatecarbu_stmt = [truncatecarbu UTF8String];
                
                sqlite3_prepare_v2(_DB, truncatecarbu_stmt, -1, &statement, NULL);
                
                
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"Reussi");
                }
                
                
                
                for (i = 0; i < idtabcarbu.count; i++)
                {
                    NSString *insertcarbu = [NSString stringWithFormat:@"INSERT INTO CARBURANT (ID, LIBELLE) VALUES (%@, '%@')", idtabcarbu[i],libtabcarbu[i]];
                    
                    NSLog(@"%@", insertcarbu);
                    const char *carbu_stmt = [insertcarbu UTF8String];
                    
                    sqlite3_prepare_v2(_DB, carbu_stmt, -1, &statement, NULL);
                    if (sqlite3_step(statement) == SQLITE_DONE)
                    {
                        NSLog(@"Reussi");
                    }
                }
                
                //RECUPERATION CARBURANT
                
                
                
                //RECUPERATION PUISSANCE
                
                
                NSMutableArray *idtabpui;
                idtabpui = [[NSMutableArray alloc] init];
                
                NSMutableArray *libtabpui;
                libtabpui = [[NSMutableArray alloc] init];
                
                NSDictionary *dictpui;
                
                NSString *id_pui;
                NSString *libellepui;
                
                
                id_pui = @"ID";
                libellepui = @"LIBELLE";
                
                
                NSData *jsonDataPui = [NSData dataWithContentsOfURL:
                                       [NSURL URLWithString:[NSString stringWithFormat:@"http://%@service_puissance.php", globalString]]];
                
                
                id jsonObjectPui = [NSJSONSerialization JSONObjectWithData:jsonDataPui options:NSJSONReadingMutableContainers error:nil];
                
                
                
                // values in foreach loop
                for (NSDictionary *dataDict in jsonObjectPui) {
                    
                    NSString *strID = [dataDict objectForKey:@"ID"];
                    NSString *strLibelle = [dataDict objectForKey:@"LIBELLE"];
                    
                    
                    dictpui = [NSDictionary dictionaryWithObjectsAndKeys:
                               strID, id_pui,
                               strLibelle, libellepui,
                               nil];
                    
                    NSLog(@"bonjour : %@",[dictpui objectForKey:@"ID"]);
                    NSLog(@"bonjour : %@",[dictpui objectForKey:@"LIBELLE"]);
                    
                    [idtabpui addObject:[dictpui objectForKey:@"ID"]];
                    [libtabpui addObject:[dictpui objectForKey:@"LIBELLE"]];
                    
                }
                
                
                
                
                NSString *truncatepui = [NSString stringWithFormat:@"DELETE FROM PUISSANCE"];
                const char *truncatepui_stmt = [truncatepui UTF8String];
                
                sqlite3_prepare_v2(_DB, truncatepui_stmt, -1, &statement, NULL);
                
                
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"Reussi");
                }
                
                
                
                for (i = 0; i < idtabpui.count; i++)
                {
                    NSString *insertpui = [NSString stringWithFormat:@"INSERT INTO PUISSANCE (ID, LIBELLE)  VALUES (%@, '%@')", idtabpui[i],libtabpui[i]];
                    const char *pui_stmt = [insertpui UTF8String];
                    
                    sqlite3_prepare_v2(_DB, pui_stmt, -1, &statement, NULL);
                    if (sqlite3_step(statement) == SQLITE_DONE)
                    {
                        NSLog(@"Reussi");
                    }
                    
                    NSLog(@"%@", insertpui);
                }
                
                //RECUPERATION PUISSANCE
                
                
                
                
                //RECUP JSON
                
            }
            
            
            
            
            
            
            
            sqlite3_finalize(statement);
        }
    }
    
    @catch (NSException *exception) {
        NSLog(@"Pas de connexion : mode hors ligne activé");
    }
    @finally {
        
    }
    
    
    
    //TEST DES VERSIONS
    
    
    
    //---------------------------INSERTION DE DONNEES--------------------------------
    
    
    
    //---------------------INSERTION DES VALEURS DANS UN TABLEAU---------------------
    
    
    
}


- (void)InsertData
{
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"frais.db"]];
    
    
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK)
    {
        
        sqlite3_stmt    *statement;
        _listetype = [[NSMutableArray alloc] init];
        _listecarbu = [[NSMutableArray alloc] init];
        
        NSString *insertpui = [NSString stringWithFormat:@"SELECT LIBELLE FROM PUISSANCE"];
        NSString *insertcarb = [NSString stringWithFormat:@"SELECT LIBELLE FROM CARBURANT"];
        
        
        const char *query_pui = [insertpui UTF8String];
        const char *query_carb = [insertcarb UTF8String];
        
        sqlite3_prepare_v2(_DB, query_pui,-1, &statement, NULL);
        
        
        if (sqlite3_prepare_v2( _DB, query_pui, -1, &statement, nil) == SQLITE_OK) {
            
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                [_listetype addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                
            }
        }
        sqlite3_finalize(statement);
        
        
        sqlite3_prepare_v2(_DB, query_carb,-1, &statement, NULL);
        
        if (sqlite3_prepare_v2( _DB, query_carb, -1, &statement, nil) == SQLITE_OK) {
            
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                [_listecarbu addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                
                
                
            }
        }
        
        
        
        
        // Calcul du taux
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT PRIX FROM TARIFS T INNER JOIN PUISSANCE P ON T.IDPUISSANCE = P.ID INNER JOIN CARBURANT C ON T.IDCARBURANT = C.ID WHERE C.ID=(SELECT ID FROM CARBURANT WHERE LIBELLE='%@') AND P.ID=(SELECT ID FROM PUISSANCE WHERE LIBELLE='%@')",[self.listecarbu objectAtIndex:[self.carbupicker selectedRowInComponent:0]], [self.listetype objectAtIndex:[self.typepicker selectedRowInComponent:0]]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        sqlite3_prepare_v2(_DB, query_stmt,-1, &statement, NULL);
        
        if (sqlite3_prepare_v2(_DB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *lib = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                _number = [lib floatValue];
                
                _taux.text = [NSString stringWithFormat:@"%.2f€/km",_number];
                
            }
            
            else {
                
                _resultat.text = @"Non défini";
                _taux.text = [NSString stringWithFormat:@""];
            }
        }
        
    }
    
    sqlite3_close(_DB);
    
    
}



- (void)Createdb
{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"frais.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    const char *dbpath = [_databasePath UTF8String];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
        
        
        if (sqlite3_open(dbpath, &_DB) == SQLITE_OK)
        {
            char *errMsg;
            
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS PUISSANCE (ID INTEGER PRIMARY KEY AUTOINCREMENT, LIBELLE TEXT);";
            
            const char *sql_stmt2 = "CREATE TABLE IF NOT EXISTS CARBURANT (ID INTEGER PRIMARY KEY AUTOINCREMENT, LIBELLE TEXT);";
            
            const char *sql_stmt3 = "CREATE TABLE IF NOT EXISTS TARIFS (ID INTEGER PRIMARY KEY AUTOINCREMENT, IDPUISSANCE INT, IDCARBURANT INT, PRIX FLOAT);";
            
            const char *sql_stmt4 = "CREATE TABLE IF NOT EXISTS VERSION (IDVERSION INTEGER PRIMARY KEY);";
            
            
            
            if (sqlite3_exec(_DB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Erreur lors création de la table 'Puissance'");
            }
            if (sqlite3_exec(_DB, sql_stmt2, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Erreur lors création de la table 'Carburant'");
            }
            if (sqlite3_exec(_DB, sql_stmt3, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Erreur lors création de la table 'Tarifs'");
            }
            if (sqlite3_exec(_DB, sql_stmt4, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Erreur lors création de la table 'Version'");
            }
            
            sqlite3_close(_DB);
        }
        
        else
        {
            NSLog(@"Failed to open/create database");
        }
        
        
        //---------------------------CREATION DE LA BDD--------------------------------
        
        
        
        //---------------------------INSERTION DE DONNEES--------------------------------
        
        sqlite3_stmt    *statement;
        
        if (sqlite3_open(dbpath, &_DB) == SQLITE_OK)
        {
            
            NSString *insertpui = [NSString stringWithFormat:@"INSERT INTO PUISSANCE (LIBELLE) VALUES (\"4CV\"),(\"6CV\")"];
            const char *pui_stmt = [insertpui UTF8String];
            
            NSString *insertcarbu = [NSString stringWithFormat:@"INSERT INTO CARBURANT (LIBELLE) VALUES (\"Diesel\"),(\"Essence\")"];
            const char *carbu_stmt = [insertcarbu UTF8String];
            
            NSString *inserttarif = [NSString stringWithFormat:@"INSERT INTO TARIFS (IDPUISSANCE, IDCARBURANT, PRIX) VALUES (1, 1, 0.52),(2, 1, 0.58),(1, 2, 0.62),(2, 2, 0.67)"];
            const char *tarif_stmt = [inserttarif UTF8String];
            
            NSString *insertversion = [NSString stringWithFormat:@"INSERT INTO VERSION (IDVERSION) VALUES (1)"];
            const char *version_stmt = [insertversion UTF8String];
            
            
            sqlite3_prepare_v2(_DB, pui_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Reussi");
            }
            
            sqlite3_prepare_v2(_DB, carbu_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Reussi");
            }
            
            sqlite3_prepare_v2(_DB, tarif_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Reussi");
            }
            
            sqlite3_prepare_v2(_DB, version_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Reussi");
            }
            
            
            
            sqlite3_finalize(statement);
            sqlite3_close(_DB);
        }
    }
}

@end

