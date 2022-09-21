package deepspace;
import java.util.ArrayList;
import java.util.Iterator;

public class SpaceStation implements SpaceFighter {
    
    // Máxima cantidad de unidades de combustible que 
    // puede tener una estación espacial
    private static final int MAXFUEL = 100;
    
    // Unidades de escudo que se pierden por cada unidad de 
    // potencia de disparo recibido
    private static final float SHIELDLOSSPERUNITSHOT = 0.1f;
    
    private float ammoPower;
    private float fuelUnits;
    private String name;
    private int nMedals;
    private float shieldPower;
    private Damage pendingDamage;
    private ArrayList<Weapon> weapons;
    private ArrayList<ShieldBooster> shieldBoosters;
    private Hangar hangar;
    
    // Fija la cantidad de combustible al valor pasado como parámetro sin
    // que nunca se exceda del límite
    private void assignFuelValue(float f) {
        if (f < MAXFUEL)
            fuelUnits = f;
        else
            fuelUnits = MAXFUEL;
    }
    
    // Si el daño pendiente (pendingDamage) no tiene efecto fija la
    // referencia al mismo a null
    private void cleanPendingDamage() {
        if (pendingDamage != null && pendingDamage.hasNoEffect())
            pendingDamage = null;
    }
    
    // Constructor
    SpaceStation(String n, SuppliesPackage supplies) {
        ammoPower = 0.0f;
        fuelUnits = 0.0f;
        shieldPower = 0.0f;
        name = n;
        nMedals = 0;
        pendingDamage = null;
        hangar = null;
        weapons = new ArrayList<Weapon>();
        shieldBoosters = new ArrayList<ShieldBooster>();
        receiveSupplies(supplies);
    }
    
    // Constructor de copia
    SpaceStation(SpaceStation station) {
        ammoPower = station.ammoPower;
        fuelUnits = station.fuelUnits;
        shieldPower = station.shieldPower;
        name = station.name;
        nMedals = station.nMedals;
        
        if (station.pendingDamage != null)
            pendingDamage = station.pendingDamage.copy();
        else pendingDamage = null;
        if (station.hangar != null)
            hangar = new Hangar(station.hangar);
        else hangar = null;
        if (station.weapons != null)
            weapons = new ArrayList<Weapon>(station.weapons);
        else weapons = null;
        if (station.shieldBoosters != null)
            shieldBoosters = new ArrayList<ShieldBooster>(station.shieldBoosters);
        else shieldBoosters = null;
    }

    // ***********************Getters***********************
    
    public float getAmmoPower() {
        return ammoPower;
    }
    
    public float getFuelUnits() {
        return fuelUnits;
    }
    
    public Hangar getHangar() {
        return hangar;
    }
    
    public String getName() {
        return name;
    }
    
    public int getNMedals() {
        return nMedals;
    }
    
    public Damage getPendingDamage() {
        return pendingDamage;
    }
    
    public ArrayList<ShieldBooster> getShieldBoosters() {
        return shieldBoosters;
    }
    
    public float getShieldPower() {
        return shieldPower;
    }
    
    // Devuelve la velocidad de la estación espacial. Esta se calcula como la 
    // fracción entre las unidades de combustible de las que dispone en la 
    // actualidad la estación espacial respecto al máximo unidades de 
    // combustible que es posible almacenar. La velocidad se representa por 
    // tanto como un número del intervalo [0,1]
    public float getSpeed() {
        return fuelUnits/MAXFUEL;
    }
    
    public SpaceStationToUI getUIversion() {
        return new SpaceStationToUI(this);
    }   

    public ArrayList<Weapon> getWeapons() {
        return weapons;
    }    
    
    //***********************Discarders***********************
    
    // Fija la referencia del hangar a null 
    // para indicar que no se dispone del mismo
    public void discardHangar() {
        hangar = null;
    }
    
    // Si se dispone de hangar, se solicita al mismo descartar el
    // potenciador de escudo con índice i
    public void discardShieldBoosterInHangar(int i) {
        if (hangar != null)
            hangar.removeShieldBooster(i);
    }
    
    // Si se dispone de hangar, se solicita al mismo descartar el arma
    // con índice i
    public void discardWeaponInHangar(int i) {
        if (hangar != null)
            hangar.removeWeapon(i);
    }    
    
    //***********************Mounters/unmounters***********************
    
    // Eliminar todas las armas y los potenciadores de escudo montados a
    // las que no les queden usos
    public void cleanUpMountedItems() {
        
        Iterator<Weapon> itWeapon = weapons.iterator();
        Iterator<ShieldBooster> itShield = shieldBoosters.iterator();
        
        while (itWeapon.hasNext()) {
            Weapon currWeapon = itWeapon.next();
            if (currWeapon.getUses() == 0)
                itWeapon.remove();
        }
        
        while (itShield.hasNext()) {
            ShieldBooster currShield = itShield.next();
            if (currShield.getUses() == 0)
                itShield.remove();
        }  
    }
    
    // Se intenta montar el potenciador de escudo con el índice i dentro
    // del hangar. Si se dispone de hangar, se le indica que elimine el 
    // potenciador de escudo de esa posición y si esta operación tiene éxito 
    // (el hangar proporciona el potenciador), se añade el mismo a
    // la colección de potenciadores en uso
    public void mountShieldBooster(int i) {
        if (hangar != null) {
            ShieldBooster newShield = hangar.removeShieldBooster(i);
            if (newShield != null)
                shieldBoosters.add(newShield);
        }
    }
    
    // Se intenta montar el arma con el índice i dentro del hangar. Si se 
    // dispone de hangar, se le indica que elimine el arma de esa posición 
    // y si esta operación tiene éxito (el hangar proporciona el arma), 
    // se añade el arma a la colección de armas en uso
    public void mountWeapon(int i) {
        if (hangar != null) {
            Weapon newWeapon = hangar.removeWeapon(i);
            if (newWeapon != null)
                weapons.add(newWeapon);
        }
    }
    
    //***********************Receivers***********************
    
    // Si no se dispone de hangar, el parámetro pasa a ser el hangar de
    // la estación espacial. Si ya se dispone de 
    // hangar esta operación no tiene efecto
    public void receiveHangar(Hangar h) {
        if (hangar == null)
            hangar = h;
    }
    
    // Si se dispone de hangar, devuelve el resultado de intentar añadir el 
    // potenciador de escudo al mismo. Si no se dispone de hangar devuelve false
    public boolean receiveShieldBooster(ShieldBooster s) {
        if (hangar != null)
            return hangar.addShieldBooster(s);
        else
            return false;
    }
    
    // La potencia de disparo, la del escudo y las unidades de combustible
    // se incrementan con el contenido del paquete de suministro
    public void receiveSupplies(SuppliesPackage s) {
        ammoPower += s.getAmmoPower();
        shieldPower += s.getShieldPower();
        assignFuelValue(fuelUnits + s.getFuelUnits());
    }
    
    // Si se dispone de hangar, devuelve el resultado de intentar
    // añadir el arma al mismo. Si no se dispone de hangar devuelve false    
    public boolean receiveWeapon(Weapon w) {
        if (hangar != null)
            return hangar.addWeapon(w);
        else
            return false;
    }
    
    // Decremento de unidades de combustible disponibles a causa de un 
    // desplazamiento. Al número de las unidades almacenadas se les resta una 
    // fracción de las mismas que es igual a la velocidad de la estación. 
    // Las unidades de combustible no pueden ser inferiores a 0
    public void move() {
        fuelUnits -= fuelUnits*getSpeed();
        if (fuelUnits < 0)
            fuelUnits = 0;
    }    
    
    // Se calcula el parámetro ajustado (adjust) a la lista de armas y
    // potenciadores de escudo de la estación y se almacena 
    // el resultado en el atributo correspondiente.
    public void setPendingDamage(Damage d) {
        pendingDamage = d.adjust(weapons, shieldBoosters);
    }
    
    // Devuelve true si la estación espacial está en un estado válido. 
    // Eso implica que o bien no se tiene ningún daño pendiente 
    // o que este no tiene efecto
    public boolean validState() {
        if (pendingDamage == null)
            return true;
        else
            return pendingDamage.hasNoEffect();
    }
    
    // Método de testeo
    public String toString() {
        String damageString = 
                (pendingDamage == null) ? "null": pendingDamage.toString();
        String hangarString = 
                (hangar == null) ? "null": hangar.toString();
        return "Name: " + name + ", ammoPower: " + ammoPower + ", fuelUnits: " +
                fuelUnits + ", shieldPower: " + shieldPower + ", nMedals: " + 
                nMedals + ", pendingDamage: " + damageString + 
                ", weapons: " + weapons.toString() + ", shieldBoosters: " + 
                shieldBoosters.toString() + ", hangar: " + hangarString;
    }
    
    // Realiza las operaciones relacionadas con la recepción del impacto de 
    // un disparo enemigo. Ello implica decrementar la potencia del escudo 
    // en función de la energía del disparo recibido como parámetro y 
    // devolver el resultado de si se ha resistido el disparo o no.
    @Override
    public ShotResult receiveShot(float shot) {
        float myProtection = protection();
        if (myProtection >= shot) {
            shieldPower -= SHIELDLOSSPERUNITSHOT * shot;
            if (shieldPower < 0.0f) shieldPower = 0.0f;
            return ShotResult.RESIST;
        } else {
            shieldPower = 0.0f;
            return ShotResult.DONOTRESIST;
        }
    }    
    
    // Recepción de un botín. Por cada elemento que indique el botín (pasado
    // como parámetro) se le pide a CardDealer un elemento de ese tipo y se 
    // intenta almacenar con el método receive*() correspondiente. Para las 
    // medallas, simplemente se incrementa su número según lo que indique el botín.
    // Devuelve la transformación que sufrirá la estación espacial
    // @return Transformation transformation
    public Transformation setLoot(Loot loot) {
        CardDealer dealer = CardDealer.getInstance();
        
        int h = loot.getNHangars();
        if (h > 0) {
            Hangar hangar = dealer.nextHangar();
            receiveHangar(hangar);
        }
        
        int elements = loot.getNSupplies();
        for (int i = 0; i < elements; ++i) {
            SuppliesPackage mySupply = dealer.nextSuppliesPackage();
            receiveSupplies(mySupply);
        }
        
        elements = loot.getNWeapons();
        for (int i = 0; i < elements; ++i) {
            Weapon myWeapon = dealer.nextWeapon();
            receiveWeapon(myWeapon);
        }
        
        elements = loot.getNShields();
        for (int i = 0; i < elements; ++i) {
            ShieldBooster myShield = dealer.nextShieldBooster();
            receiveShieldBooster(myShield);
        }
        
        int medals = loot.getNMedals();
        nMedals += medals;
        
        if (loot.getEfficient())
            return Transformation.GETEFFICIENT;
        else if (loot.spaceCity())
            return Transformation.SPACECITY;
        else
            return Transformation.NOTRANSFORM;
    }
    
    // Realiza un disparo y se devuelve la energía o potencia del mismo. 
    // Para ello se multiplica la potencia de disparo por los factores 
    // potenciadores proporcionados por todas las armas.
    @Override
    public float fire() {
        int size = weapons.size();
        float factor = 1.0f;
        Weapon w;
        for (int i = 0; i < size; ++i) {
            w = weapons.get(i);
            factor *= w.useIt();
        }
        return ammoPower * factor;
    }    
    
    // Se usa el escudo de protección y se devuelve la energía del mismo. 
    // Para ello se multiplica la potencia del escudo por los factores 
    // potenciadores proporcionados por todos los potenciadores de 
    // escudos de los que se dispone.
    @Override
    public float protection() {
        int size = shieldBoosters.size();
        float factor = 1.0f;
        ShieldBooster sh;
        for (int i = 0; i < size; ++i) {
            sh = shieldBoosters.get(i);
            factor *= sh.useIt();
        }
        return shieldPower * factor;
    }
    
    // Se intenta descartar el potenciador de escudo con índice i de la
    // colección de potenciadores de escudo en uso. Además de perder el 
    // potenciador de escudo, se debe actualizar el daño pendiente 
    // (pendingDamage) si es que se tiene alguno.
    public void discardShieldBooster(int i) {
        int size = shieldBoosters.size();
        if (i >= 0 && i < size) {
            ShieldBooster sh = shieldBoosters.remove(i);
            if (pendingDamage != null) {
                pendingDamage.discardShieldBooster();
                cleanPendingDamage();
            }
        }
    }
    
    // Se intenta descartar el arma con índice i de la colección de armas en uso.
    // Además de perder el arma, se debe actualizar el daño pendiente 
    // (pendingDamage) si es que se tiene alguno.
    public void discardWeapon(int i) {
        int size = weapons.size();
        if (i >= 0 && i < size) {
            Weapon w = weapons.remove(i);
            if (pendingDamage != null) {
                pendingDamage.discardWeapon(w);
                cleanPendingDamage();
            }
        }
    }    
}
