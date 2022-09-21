/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package deepspace;

/**
 *
 * @author eduardo
 */
public class BetaPowerEfficientSpaceStation extends PowerEfficientSpaceStation {
    private static final float EXTRAEFFICIENCY = 1.2f;
    private Dice dice;
    
    BetaPowerEfficientSpaceStation(SpaceStation station) {
        super(station);
        dice = new Dice();
    }
    
    // Realiza un disparo y se devuelve la energía o potencia del mismo. 
    // Para ello se multiplica la potencia de disparo por los factores 
    // potenciadores proporcionados por todas las armas.
    @Override
    public float fire() {
        if (dice.extraEfficiency())
            return super.fire()*EXTRAEFFICIENCY;
        else
            return super.fire();
    }    
    
    @Override
    public BetaPowerEfficientSpaceStationToUI getUIversion() {
        return new BetaPowerEfficientSpaceStationToUI(this);
    }
    
    @Override
    public String toString() {
        return "Beta " + super.toString();
    }
}
