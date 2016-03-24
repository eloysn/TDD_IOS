//
//  FRTMoney.m
//  Wallet
//
//  Created by Eloy Sanz Navarro on 24/3/16.
//  Copyright © 2016 FratelliApps. All rights reserved.
//

#import "FRTMoney.h"
#import "NSObject+GNUStepAddons.h"
#import "FRTBroker.h"

@interface FRTMoney ()
@property (nonatomic, strong) NSNumber *amount;
@end


@implementation FRTMoney

+ (instancetype) euroWithAmount: (NSInteger) amount{
    return [[FRTMoney alloc] initWithAmount:amount
                                   currency:@"EUR"];
}
+ (instancetype) dollarWithAmount: (NSInteger) amount{
    return [[FRTMoney alloc] initWithAmount:amount
                                   currency:@"USD"];
}

- (id) initWithAmount: (NSInteger) amount
             currency: (NSString *) currency{
    if (self = [super init]) {
        _amount = @(amount);
        _currency = currency;
    }
    return self;
}

//- (FLGMoney *) times: (NSUInteger) multiplier{
//    // No se debería llamar, sino que se debería
//    // usar el de la sub-clase
//    return [self subclassResponsibility:_cmd]; // _cmd: parametro oculto de Objective-C que identifica el selector actual ("self" también es un parametro de ese tipo)
//}

- (id<FRTMoney>) times: (NSUInteger) multiplier{
    return [[FRTMoney alloc] initWithAmount:[self.amount integerValue] * multiplier
                                   currency:self.currency];
}

- (id<FRTMoney>) plus: (FRTMoney *) other{
    return [[FRTMoney alloc] initWithAmount:([self.amount integerValue] + [[other amount] integerValue])
                                   currency:self.currency];
}

- (id<FRTMoney>) minus: (FRTMoney *) other{
    if ([other.amount integerValue] > [self.amount integerValue]) {
        [NSException raise:@"TryingToSubstractBiggestAmountThanExistingException"
                    format:@"Imposible to substract %@ %@ form %@ %@", other.amount, other.currency, self.amount, self.currency];
        
    }
    return [[FRTMoney alloc] initWithAmount:([self.amount integerValue] - [[other amount] integerValue])
                                   currency:self.currency];
}

- (FRTMoney *)reduceToCurrency: (NSString *) currency
                    withBroker: (FRTBroker *) broker{
    FRTMoney *result;
    double rate = [[broker.rates objectForKey:[broker keyFromCurrency:self.currency
                                                           toCurrency:currency]] doubleValue];
    
    // Comprobamos si divisa de origen y destino son iguales
    if ([self.currency isEqual:currency]) {
        result = self;
    }
    else if (rate == 0){
        // No hay tasa de conversion, lanzar excepcion
        [NSException raise:@"NoConversionRateException"
                    format:@"Must have a conversion for %@ to %@", self.currency, currency];
    }
    else{
        
        NSInteger newAmount = [self.amount integerValue] * rate;
        
        result = [[FRTMoney alloc] initWithAmount:newAmount
                                         currency:currency];
    }
    return result;
}

#pragma mark - Overwritten

- (NSString *) description{
    return [NSString stringWithFormat:@"<%@: %@ %@>", [self class], [self currency], [self amount]];
}

- (BOOL) isEqual:(id)object{
    if ([[self currency] isEqual:[object currency]]) {
        return [self amount] == [object amount];
    }else{
        return NO;
    }
}

// Siempre que se implemente "isEqual", se debe implamentar "hash"
// Todos los objetos que devuelvan "true" en "isEqual", deben tener el mismo Hash
- (NSUInteger) hash{
    return [self.amount integerValue];
}

@end
