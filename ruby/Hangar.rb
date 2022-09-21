require_relative 'HangarToUI'
require_relative 'ShieldBooster'
require_relative 'Weapon'


module Deepspace
    class Hangar
        def initialize(initMaxElemets)
            @maxElements = initMaxElemets
            @shieldBoosters = []
            @weapons = []
        end

        def self.newCopy(h)
            copy = new(h.maxElements)

            h.shieldBoosters.each do |shieldBooster|
                copy.addShieldBooster(shieldBooster)
            end

            h.weapons.each do |weapon|
                copy.addWeapon(weapon)
            end

            return copy
        end


        # Devuelve true si aún hay espacio para añadir elementos y que por lo
        # tanto no se ha llegado a la capacidad máxima
        private def spaceAvailable
            @shieldBoosters.length + @weapons.length < @maxElements
        end

        # Añade el arma al hangar si queda espacio en el Hangar,
        # devolviendo true en ese caso. Devuelve false en cualquier otro caso.
        def addWeapon(w)
            if spaceAvailable
                @weapons.push(w)
                true
            else
                false
            end
        end

        # Añade el potenciador de escudo al hangar si queda espacio. Devuelve
        # true si ha sido posible añadir el potenciador, false en otro caso
        def addShieldBooster(w)
            if spaceAvailable
                @shieldBoosters.push(w)
                true
            else
                false
            end
        end

        
        # Get
        attr_reader :maxElements, :shieldBoosters, :weapons


        # Elimina el potenciador de escudo número s del hangar y lo devuelve,
        # siempre que este exista. Si el índice suministrado es incorrecto
        # devuelve null
        def removeShieldBooster(s)
            if s<0 || s>=@shieldBoosters.length
                nil
            else
                @shieldBoosters.delete_at(s)
            end
        end

        # Elimina el arma número w del hangar y la devuelve, siempre que
        # esta exista. Si el índice suministrado es incorrecto devuelve null
        def removeWeapon(w)
            if w<0 || w>=@weapons.length
                nil
            else
                @weapons.delete_at(w)
            end
        end


        def getUIversion
            HangarToUI.new(self)
        end
        
        # Representacion del objeto en String
        def to_s
            "Max Elements: #{@maxElements}, Weapons: [#{@weapons.join(", ")}], Shields: [#{@shieldBoosters.join(", ")}]"
        end
    end
end