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



