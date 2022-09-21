package deepspace;

import java.util.ArrayList;
import java.util.Iterator;

public class SpecificDamage extends Damage {
    private ArrayList<WeaponType> weapons;
    
    
    // Constructor
    SpecificDamage(ArrayList<WeaponType> wl, int s){
        super(s);
        
        // Realiza una copia del array elemento por elemento,
        // guardándolo en una dirección distinta
        weapons = new ArrayList<WeaponType>(wl);
    }
    
    // Constructor de copia
    SpecificDamage(SpecificDamage other){
        this(other.weapons, other.getNShields());
    }
    
    // Método de copia
    @Override
    public SpecificDamage copy(){
        return new SpecificDamage(new ArrayList<WeaponType>(weapons), getNShields());
    }
    
    // Devuelve el índice de la posición de la primera arma de la colección de
    // armas (primer parámetro) cuyo tipo coincida con el tipo indicado
    // por el segundo parámetro. Devuelve -1 si no hay ninguna arma en la
    // colección del tipo indicado por el segundo parámetro
    // @param Array<Weapon> w
    // @param WeaponType t
    // @return int i
    private int arrayContainsType(ArrayList<Weapon> w,WeaponType t){
        for (int i=0; i<w.size(); i++){
            if (w.get(i).getType() == t)
                return i;
        }
        return -1;
        
//        int i=0;
//        Iterator<Weapon> it = w.iterator();
//        while (it.hasNext()){
//            if (it.next().getType() == t)
//                return i;
//            else
//                i++;
//        }   
//        return -1;
    }
    
    // Devuelve una versión ajustada del objeto a las colecciones de armas y
    // potenciadores de escudos suministradas como parámetro.
    // Partiendo del daño representado por el objeto que recibe este mensaje,
    // se devuelve una copia del mismo pero reducida si es necesario para que
    // no implique perder armas o potenciadores de escudos que no están en
    // las colecciones de los parámetros
    // @param Array<Weapon> w
    // @param Array<ShieldBooster> s
    // @return SpecificDamage specificDamage
    @Override
    public SpecificDamage adjust(ArrayList<Weapon> w, ArrayList<ShieldBooster> s){
        // Nº de shields
        int nShieldsNew = Integer.min(getNShields(), s.size());
        
        // Damage con array de weapons
        
        ArrayList<Weapon> wAux = new ArrayList<>(w);
        ArrayList<WeaponType> weaponsResult = new ArrayList<>();
        
        
        for (int i=0; i<weapons.size(); i++){
            int pos = arrayContainsType(wAux, weapons.get(i));
            
            if (pos != -1){
                // Si se ha encontrado el elemento, lo añadimos al resultado
                // y lo borramos de wAux
                weaponsResult.add(weapons.get(i));
                wAux.remove(pos);
            }
        }
        return new SpecificDamage(weaponsResult, nShieldsNew);
    }
    
    
    // Intenta eliminar el tipo del arma pasada como parámetro de esa lista.
    // @param Weapon w
    @Override
    public void discardWeapon(Weapon w){
        weapons.remove(w.getType());
    }
    
    // Devuelve true si el daño representado no tiene ningún efecto. Esto
    // quiere decir que no implica la pérdida de ningún tipo de accesorio
    // (armas o potenciadores de escudo)
    // @return boolean
    @Override
    public boolean hasNoEffect(){
        return getNShields()==0 && weapons.isEmpty();
    }
    
    public ArrayList<WeaponType> getWeapons(){
        return weapons;
    }
    
    @Override
    SpecificDamageToUI getUIversion(){
        return new SpecificDamageToUI(this);
    }
    
    // Representación del objeto en String
    @Override
    public String toString(){
        return "nShields: "+getNShields()+", weapons: "+weapons.toString();
    }
}
