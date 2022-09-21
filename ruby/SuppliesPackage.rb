# Representa a un paquete de suministros para una estación espacial. Puede
# contener armamento, combustible y/o energía para los escudos.

module Deepspace
    class SuppliesPackage
        def initialize(initAmmoPower, initFuelUnits, initShieldPower)
            @ammoPower = initAmmoPower
            @fuelUnits = initFuelUnits
            @shieldPower = initShieldPower
        end

        # Constructor de copia
        def self.newCopy(other)
            new(other.ammoPower, other.fuelUnits, other.shieldPower)
        end

        def ammoPower
            @ammoPower
        end

        def fuelUnits
            @fuelUnits
        end

        def shieldPower
            @shieldPower
        end

        def to_s
            "ammoPower: #@ammoPower, fuelUnits: #@fuelUnits, shieldPower: #@shieldPower";
        end
    end
end