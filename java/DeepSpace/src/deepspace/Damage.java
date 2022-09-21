package deepspace;

import java.util.ArrayList;
import java.util.Iterator;

abstract class Damage {
    private int nShields;
    
    Damage(int s){
        nShields = s;
    }
    
    // Método de copia
    public abstract Damage copy();
    
    // Devuelve una versión ajustada del objeto a las colecciones de armas y
    // potenciadores de escudos suministradas como parámetro.
    // Partiendo del daño representado por el objeto que recibe este mensaje,
    // se devuelve una copia del mismo pero reducida si es necesario para que
    // no implique perder armas o potenciadores de escudos que no están en
    // las colecciones de los parámetros
    // @param Array<Weapon> w
    // @param Array<ShieldBooster> s
    // @return Damage damage
    public abstract Damage adjust(ArrayList<Weapon> w, ArrayList<ShieldBooster> s);
    
    
    // Elimina el arma pasada como parámetro
    // @param Weapon w
    public abstract void discardWeapon(Weapon w);
    
    // Decrementa en una unidad el número de potenciadores de escudo que
    // deben ser eliminados. Ese contador no puede ser inferior a cero
    // en ningún caso
    public void discardShieldBooster(){
        if (nShields > 0)
            nShields--;
    }
    
    // Devuelve true si el daño representado no tiene ningún efecto. Esto
    // quiere decir que no implica la pérdida de ningún tipo de accesorio
    // (armas o potenciadores de escudo)
    // @return boolean
    public abstract boolean hasNoEffect();
    
    
    public int getNShields(){
        return nShields;
    }
    
    abstract DamageToUI getUIversion();
    
    // Representación del objeto en String
    public abstract String toString();
}