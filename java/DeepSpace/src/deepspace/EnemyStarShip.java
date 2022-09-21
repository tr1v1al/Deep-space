package deepspace;

public class EnemyStarShip implements SpaceFighter {
    private String name;
    private float ammoPower;
    private float shieldPower;
    private Loot loot;
    private Damage damage;
    
    // Constructor
    // @param String n
    // @param float a
    // @param float s
    // @param Loot l
    // @param Damage d
    EnemyStarShip(String n, float a, float s, Loot l, Damage d){
        name = n;
        ammoPower = a;
        shieldPower = s;
        loot = l;
        damage = d;
    }
    
    EnemyStarShip(EnemyStarShip e){
        name = e.name;
        ammoPower = e.ammoPower;
        shieldPower = e.shieldPower;
        loot = e.loot;
        damage = e.damage;
    }
    
    
    // Get
    public float getAmmoPower(){
        return ammoPower;
    }
    public Damage getDamage(){
        return damage;
    }
    public Loot getLoot(){
        return loot;
    }
    public String getName(){
        return name;
    }
    public float getShieldPower(){
        return shieldPower;
    }
    
    
    // Devuelve el nivel de energía de disparo de la nave enemiga (ammoPower)
    // @return float ammoPower
    @Override
    public float fire(){
        return ammoPower;
    }
    
    // Devuelve el nivel de energía del escudo de la nave enemiga (shieldPower)
    // @return float shieldPower
    @Override
    public float protection(){
        return shieldPower;
    }
    
    // Devuelve el resultado que se produce al recibir un disparo de una
    // determinada potencia (pasada como parámetro). Si el nivel de la
    // protección de los escudos es menor que la intensidad del disparo, la
    // nave enemiga no resiste (DONOTRESIST). En caso contrario resiste el
    // disparo (RESIST). Se devuelve el resultado producido por el disparo
    // recibido.
    // @param float shot
    // @return ShotResult result
    @Override
    public ShotResult receiveShot(float shot){
        if (shieldPower < shot)
            return ShotResult.DONOTRESIST;
        else
            return ShotResult.RESIST;
    }
    
    EnemyToUI getUIversion(){
        return new EnemyToUI(this);
    }
    
    public String toString(){
        return "name: "+name+", ammoPower: "+ammoPower+", shieldPower: "+
                shieldPower+", loot: ("+loot+"), damage: ("+damage+")";
    }
}