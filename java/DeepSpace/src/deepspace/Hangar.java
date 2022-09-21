package deepspace;

import java.util.ArrayList;

public class Hangar {
    // Máximo de escudos y armas de la estación
    private int maxElements;
    // Array con shieldbooster
    private ArrayList<ShieldBooster> shieldBoosters;
    // Array con weapon
    private ArrayList<Weapon> weapons;
    
    
    
    
    Hangar(int capacity){
        maxElements = capacity;
        shieldBoosters = new ArrayList<>();
        weapons = new ArrayList<>();
    }
    
    Hangar(Hangar h){
        this.maxElements = h.maxElements;
        shieldBoosters = new ArrayList<>(h.shieldBoosters);
        weapons = new ArrayList<>(h.weapons);
        
        /*
        for (int i=0; i<h.shieldBoosters.size(); i++)
            addShieldBooster(h.shieldBoosters.get(i));
        for (int i=0; i<h.weapons.size(); i++)
            addWeapon(h.weapons.get(i));
        */
        
        /*
        Iterator<ShieldBooster> itS = h.shieldBoosters.iterator();
        Iterator<Weapon> itW = h.weapons.iterator();
        while (itS.hasNext())
            addShieldBooster(itS.next());
        while (itW.hasNext())
            addWeapon(itW.next());
        */
    }
    
    
    // Devuelve true si aún hay espacio para añadir elementos y que por lo
    // tanto no se ha llegado a la capacidad máxima
    private boolean spaceAvailable(){
        return shieldBoosters.size() + weapons.size() < maxElements;
    }
    
    // Añade el arma al hangar si queda espacio en el Hangar,
    // devolviendo true en ese caso. Devuelve false en cualquier otro caso.
    public boolean addWeapon(Weapon w){
        if (spaceAvailable()){
            weapons.add(w);
            return true;
        }
        else
            return false;
    }
    
    // Añade el potenciador de escudo al hangar si queda espacio. Devuelve
    // true si ha sido posible añadir el potenciador, false en otro caso
    public boolean addShieldBooster(ShieldBooster w){
        if (spaceAvailable()){
            shieldBoosters.add(w);
            return true;
        }
        else
            return false;
    }
    
    
    // Devuelve el número máximo de elementos
    public int getMaxElements(){
        return maxElements;
    }
    
    // Devuelve el array ShieldBoosters
    public ArrayList<ShieldBooster> getShieldBoosters(){
        //return shieldBoosters;
        return new ArrayList<ShieldBooster>(shieldBoosters);
    }
    
    // Devuelve el array Weapons
    public ArrayList<Weapon> getWeapons(){
        //return weapons;
        return new ArrayList<Weapon>(weapons);
    }
    
    
    // Elimina el potenciador de escudo número s del hangar y lo devuelve,
    // siempre que este exista. Si el índice suministrado es incorrecto
    // devuelve null
    public ShieldBooster removeShieldBooster(int s){
        if (s < 0 || s >= shieldBoosters.size())
            return null;
        else
            return shieldBoosters.remove(s);
    }
    
    // Elimina el arma número w del hangar y la devuelve, siempre que
    // esta exista. Si el índice suministrado es incorrecto devuelve null
    public Weapon removeWeapon(int w){
        if (w < 0 || w >= weapons.size())
            return null;
        else
            return weapons.remove(w);
    }
    
    
    HangarToUI getUIversion(){
        return new HangarToUI(this);
    }
    
    // Representacion del objeto en String
    public String toString(){
        return "Max Elements: " + maxElements + ", Weapons: " +
                weapons.toString() + ", Shields: " + shieldBoosters.toString();
    }
}
