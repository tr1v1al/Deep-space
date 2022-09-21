package deepspace;

import java.util.ArrayList;

public class NumericDamage extends Damage {
    private int nWeapons;
    
    NumericDamage(int w, int s){
        super(s);
        nWeapons = w;
    }
    
    // Constructor de copia
    NumericDamage(NumericDamage other){
        this(other.nWeapons, other.getNShields());
    }
    
    // Método de copia
    @Override
    public NumericDamage copy(){
        return new NumericDamage(nWeapons, getNShields());
    }
    
    // Devuelve una versión ajustada del objeto a las colecciones de armas y
    // potenciadores de escudos suministradas como parámetro.
    // Partiendo del daño representado por el objeto que recibe este mensaje,
    // se devuelve una copia del mismo pero reducida si es necesario para que
    // no implique perder armas o potenciadores de escudos que no están en
    // las colecciones de los parámetros
    // @param Array<Weapon> w
    // @param Array<ShieldBooster> s
    // @return NumericDamage numericDamage
    @Override
    public NumericDamage adjust(ArrayList<Weapon> w, ArrayList<ShieldBooster> s){
        return new NumericDamage(Integer.min(nWeapons, w.size()), Integer.min(getNShields(), s.size()));
    }
    
    
    // Decrementa en una unidad el contador de armas que deben ser eliminadas.
    // Ese contador no puede ser inferior a cero en ningún caso
    // @param Weapon w
    @Override
    public void discardWeapon(Weapon w){
        if (nWeapons > 0)
            nWeapons--;
    }
    
    // Devuelve true si el daño representado no tiene ningún efecto. Esto
    // quiere decir que no implica la pérdida de ningún tipo de accesorio
    // (armas o potenciadores de escudo)
    // @return boolean
    @Override
    public boolean hasNoEffect(){
        return getNShields()==0 && nWeapons==0;
    }
    
    public int getNWeapons(){
        return nWeapons;
    }
    
    @Override
    NumericDamageToUI getUIversion(){
        return new NumericDamageToUI(this);
    }
    
    // Representación del objeto en String
    @Override
    public String toString(){
        return "nShields: "+getNShields()+", nWeapons: "+ nWeapons;
    }
}
