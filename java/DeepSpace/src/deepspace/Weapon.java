package deepspace;


// Representa a las armas delas que puede disponer una estación espacial
// para potenciar su energía al disparar

class Weapon implements CombatElement {
    private String name;
    private WeaponType type;
    private int uses;
    
    Weapon(String name, WeaponType type, int uses){
        this.name = name;
        this.type = type;
        this.uses = uses;
    }
    
    Weapon(Weapon other){
        this.name = other.name;
        this.type = other.type;
        this.uses = other.uses;
    }
    
    public WeaponType getType(){
        return type;
    }
    
    @Override
    public int getUses(){
        return uses;
    }
    
    // Devuelve la potencia de disparo indicada por el tipo de arma
    public float power(){
        return type.getPower();
    }
    
    // Si el valor de uses es mayor que 0, lo decrementa en 1 y devuelve el
    // valor del método power(), en otro caso devuelve 1.0
    @Override
    public float useIt(){
        if (uses > 0){
            uses--;
            return power();
        }
        else
            return 1.0f;
    }
    
    WeaponToUI getUIversion(){
        return new WeaponToUI(this);
    }
    
    public String toString(){
        return "name: " + name +
                ", type: " + type +
                ", uses: " + uses;
    }
}
