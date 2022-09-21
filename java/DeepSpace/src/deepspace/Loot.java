package deepspace;


// Representa el botín obtenido al vencer a una nave enemiga

class Loot {
    private int nSupplies;
    private int nWeapons;
    private int nShields;
    private int nHangars;
    private int nMedals;
    private boolean efficient;   // La estación se convierte en eficiente o no
    private boolean spaceCity;      // La estación se convierte en ciudad o no
    
    Loot(int nSupplies, int nWeapons, int nShields, int nHangars, int nMedals){
        this.nSupplies = nSupplies;
        this.nWeapons = nWeapons;
        this.nShields = nShields;
        this.nHangars = nHangars;
        this.nMedals = nMedals;
        this.efficient = false;
        this.spaceCity = false;
    }
    
    Loot(int nSupplies, int nWeapons, int nShields, int nHangars, int nMedals, boolean ef, boolean city){
        this.nSupplies = nSupplies;
        this.nWeapons = nWeapons;
        this.nShields = nShields;
        this.nHangars = nHangars;
        this.nMedals = nMedals;
        this.efficient = ef;
        this.spaceCity = city;
    }
    
    public int getNSupplies(){
        return nSupplies;
    }
    
    public int getNWeapons(){
        return nWeapons;
    }
    
    public int getNShields(){
        return nShields;
    }
    
    public int getNHangars(){
        return nHangars;
    }
    
    public int getNMedals(){
        return nMedals;
    }
    
    public boolean getEfficient(){
        return efficient;
    }
    
    public boolean spaceCity(){
        return spaceCity;
    }
    
    LootToUI getUIversion(){
        return new LootToUI(this);
    }
    
    public String toString(){
        return "nSupplies: " + nSupplies +
                ", nWeapons: " + nWeapons +
                ", nShields: " + nShields +
                ", nHangars: " + nHangars +
                ", nMedals: " + nMedals +
                ", getEfficient: " + getEfficient() +
                ", spaceCity: " + spaceCity;
    }
}
