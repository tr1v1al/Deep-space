package deepspace;

import java.util.ArrayList;

public class SpaceCity extends SpaceStation{
    // Estación espacial del jugador
    private SpaceStation base;
    // Estación espacial del resto de jugadores
    private ArrayList<SpaceStation> collaborators;
    
    // Constructor
    // @param SpaceStation base
    // @param ArrayList<SpaceStation> rest
    public SpaceCity(SpaceStation base, ArrayList<SpaceStation> rest){
        super(base);
        this.base = base;
        collaborators = new ArrayList<SpaceStation>(rest);
    }
    
    public ArrayList<SpaceStation> getCollaborators(){
        return collaborators;
    }
    
    // Realiza un disparo y se devuelve la energía o potencia del mismo. 
    // Para ello se multiplica la potencia de disparo por los factores
    // potenciadores proporcionados por todas las armas y suma la de
    // cada estación.
    @Override
    public float fire(){
        float factor = base.fire();
        
        for (int i=0; i<collaborators.size(); i++)
            factor += collaborators.get(i).fire();
        
        return factor;
    }
    
    // Se usa el escudo de protección y se devuelve la energía del mismo. 
    // Para ello se multiplica la potencia del escudo por los factores 
    // potenciadores proporcionados por todos los potenciadores de 
    // escudos de los que se dispone y suma la de cada estación.
    @Override
    public float protection() {
        float factor = base.protection();
        
        for (int i=0; i<collaborators.size(); i++)
            factor += collaborators.get(i).protection();
        
        return factor;
    }
    
    // Recepción de un botín. 
    // La ciudad espacial no sufrirá ninguna transformación
    // @return Transformation transformation
    @Override
    public Transformation setLoot(Loot loot) {
        super.setLoot(loot);
        return Transformation.NOTRANSFORM;
    }
    
    
    
    @Override
    public SpaceCityToUI getUIversion(){
        return new SpaceCityToUI(this);
    }
}
