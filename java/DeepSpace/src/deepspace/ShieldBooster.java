package deepspace;


// Representa a los potenciadores de escudo que pueden tener las estaciones
// espaciales
class ShieldBooster implements CombatElement {
    private String name;
    private float boost;
    private int uses;
    
    ShieldBooster(String name, float boost, int uses){
        this.name = name;
        this.boost = boost;
        this.uses = uses;
    }
    
    ShieldBooster(ShieldBooster other){
        this.name = other.name;
        this.boost = other.boost;
        this.uses = other.uses;
    }
    
    public float getBoost(){
        return boost;
    }
    
    @Override
    public int getUses(){
        return uses;
    }
    
    @Override
    public float useIt(){
        if (uses > 0){
            uses--;
            return boost;
        }
        else
            return 1.0f;
    }
    
    ShieldToUI getUIversion(){
        return new ShieldToUI(this);
    }
    
    public String toString(){
        return "name: " + name +
                ", boost: " + boost +
                ", uses: " + uses;
    }
}
