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
public class PowerEfficientSpaceStation extends SpaceStation {
    private static final float EFFICIENCYFACTOR  = 1.10f;
    public PowerEfficientSpaceStation(SpaceStation station) {
        super(station);
    }
    
    // Realiza un disparo y se devuelve la energía o potencia del mismo. 
    // Para ello se multiplica la potencia de disparo por los factores 
    // potenciadores proporcionados por todas las armas.
    @Override
    public float fire() {
        return super.fire()*EFFICIENCYFACTOR;
    }
    
    // Se usa el escudo de protección y se devuelve la energía del mismo. 
    // Para ello se multiplica la potencia del escudo por los factores 
    // potenciadores proporcionados por todos los potenciadores de 
    // escudos de los que se dispone.
    @Override
    public float protection() {
        return super.protection()*EFFICIENCYFACTOR;
    }
    
    // Recepción de un botín. Por cada elemento que indique el botín (pasado
    // como parámetro) se le pide a CardDealer un elemento de ese tipo y se 
    // intenta almacenar con el método receive*() correspondiente. Para las 
    // medallas, simplemente se incrementa su número según lo que indique el botín.
    // Devuelve la transformación que sufrirá la estación espacial
    // @return Transformation transformation
    public Transformation setLoot(Loot loot) {
        super.setLoot(loot);
        if (loot.getEfficient())
            return Transformation.GETEFFICIENT;
        else
            return Transformation.NOTRANSFORM;
    }
    
    @Override
    public PowerEfficientSpaceStationToUI getUIversion() {
        return new PowerEfficientSpaceStationToUI(this);
    }
    
    @Override
    public String toString() {
        return "Power efficient space station: " + super.toString();
    }
}
