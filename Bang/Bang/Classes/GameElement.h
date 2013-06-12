//
//  GameElement.h
//  Bang
//
//  Created by Martin on 5/21/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

typedef enum{
    stateWillStart,
    stateStart,
    statePlaying,
    stateEnd,
    statePause,
}GameState;

typedef enum{
    modeTutorial,
    modeNormal,
    modeTimeAttack,
    modeSurvial,
}GameMode;

struct GameSettings {
    GameMode gameMode;
    int setId;
};
typedef struct GameSettings GameSettings;

struct GameResult {
    float roundScore;
    int bestRoundCombo;
    float comboBonus;
    int multiplier;
    signed int coins;
};
typedef struct GameResult GameResult;

struct UserData {
    int uniqueId;
    float bestNormalScore;
    int bestNormalCombo;
    float bestSurvivalScore;
    int bestSurvivalCombo;
    float bestLuckyScore; 
    int bestLuckyCombo;
    int multiplier;
    int coins;
};
typedef struct UserData UserData;
static inline UserData UserDataMakeDefault(/*int uniqueId,
                                float bestNormalScore,
                                int bestNormalCombo,
                                float bestSurvivalScore,
                                int bestSurvivalCombo,
                                float bestLuckyScore,
                                int bestLuckyCombo,
                                int multiplier,
                                    int coins*/){
    
                                        UserData userData;
                                        userData.uniqueId = 1;
                                        userData.bestNormalScore = 0;
                                        userData.bestNormalCombo = 0;
                                        userData.bestSurvivalScore = 0;
                                        userData.bestSurvivalCombo = 0;
                                        userData.bestLuckyScore = 0;
                                        userData.bestLuckyCombo = 0;
                                        userData.multiplier = 1;
                                        userData.coins = 0;
                                        return userData;
    
};



