package deepspace;


// Representa a un paquete de suministros para una estación espacial. Puede
// contener armamento, combustible y/o energía para los escudos.

class SuppliesPackage {
    private float ammoPower;
    private float fuelUnits;
    private float shieldPower;
    
    SuppliesPackage(float ammoPower, float fuelUnits, float shieldPower){
        this.ammoPower = ammoPower;
        this.fuelUnits = fuelUnits;
        this.shieldPower = shieldPower;
    }
    
    SuppliesPackage(SuppliesPackage other){
        this.ammoPower = other.ammoPower;
        this.fuelUnits = other.fuelUnits;
        this.shieldPower = other.shieldPower;
    }
    
    public float getAmmoPower(){
        return ammoPower;
    }
    
    public float getFuelUnits(){
        return fuelUnits;
    }
    
    public float getShieldPower(){
        return shieldPower;
    }
    
    public String toString(){
        return "ammoPower: " + ammoPower +
                ", fuelUnits: " + fuelUnits +
                ", shieldPower: " + shieldPower;
    }
}
