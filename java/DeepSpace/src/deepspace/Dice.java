package deepspace;

import java.util.Random;


// Esta clase toma las decisiones que dependen del azar en el juego

class Dice {
    private final float NHANGARSPROB;
    private final float NSHIELDSPROB;
    private final float NWEAPONSPROB;
    private final float FIRSTSHOTPROB;
    private final float EXTRAEFFICIENCYPROB;
    
    private Random generator;
    
    Dice(){
        NHANGARSPROB = 0.25f;
        NSHIELDSPROB = 0.25f;
        NWEAPONSPROB = 0.33f;
        FIRSTSHOTPROB = 0.5f;
        EXTRAEFFICIENCYPROB = 0.8f;
        generator = new Random();
    }
    
    public boolean extraEfficiency() {
        return generator.nextFloat() < EXTRAEFFICIENCYPROB;
    }
    
    // Devuelve el número de hangares que recibirá una estación espacial al
    // ser creada
    int initWithNHangars(){
        if (generator.nextFloat() < NHANGARSPROB)
            return 0;
        else
            return 1;
    }
    
    // Determina el nº de armas que recibirá una estación al ser creada
    int initWithNWeapons(){
        float prob = generator.nextFloat();
        if (prob < NWEAPONSPROB)
            return 1;
        else if (prob < NWEAPONSPROB*2)
            return 2;
        else
            return 3;
    }
    
    // Determina el nº de potenciadores de escudo que reibirá una estación
    // al ser creada
    int initWithNShields(){
        if (generator.nextFloat() < NSHIELDSPROB)
            return 0;
        else
            return 1;
    }
    
    // Determina el índice del jugador que iniciará la partida
    int whoStarts(int nPlayers){
        return generator.nextInt(nPlayers);
    }
    
    // Determina que personaje dispara primero en un combate, la estación
    // espacial o la nave enemiga
    GameCharacter firstShot(){
        if (generator.nextFloat() < FIRSTSHOTPROB)
            return GameCharacter.SPACESTATION;
        else
            return GameCharacter.ENEMYSTARSHIP;
    }
    
    // Determina si la estación espacial se moverá para esquivar el disparo
    // La probabilidad de moverse será mayor cuanto más cerca está la velocidad
    // potencial actual de la estación espacial de su velocidad máxima potencial
    boolean spaceStationMoves(float speed){
        if (generator.nextFloat() < speed)
            return true;
        else
            return false;
    }
    
    // Representacion del objeto en String
    public String toString(){
        return "NHANGARSPROB: " + NHANGARSPROB + ", NSHIELDSPROB: " +
                NSHIELDSPROB + ", NWEAPONSPROB: " + NWEAPONSPROB + 
                ", FIRSTSHOTPROB: " + FIRSTSHOTPROB;
    }
}
