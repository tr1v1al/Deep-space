#encoding: utf-8
require_relative 'SuppliesPackage'
require_relative 'Hangar'
require_relative 'Damage'
require_relative 'ShieldBooster'
require_relative 'SpaceStationToUI'
require_relative 'Weapon'
require_relative 'ShotResult'
require_relative 'Loot'
require_relative 'CardDealer'
require_relative 'Transformation'

module Deepspace
    class SpaceStation
        # Máxima cantidad de unidades de combustible que 
        # puede tener una estación espacial
        MAXFUEL = 100
        
        # Unidades de escudo que se pierden por cada unidad de 
        # potencia de disparo recibido
        SHIELDLOSSPERUNITSHOT = 0.1

        # Constructor
        def initialize(n, supplies)
            @ammoPower = 0.0
            @fuelUnits = 0.0
            @shieldPower = 0.0
            @name = n
            @nMedals = 0
            @pendingDamage = nil
            @hangar = nil
            @weapons = []
            @shieldBoosters = []
            receiveSupplies(supplies)
        end

        # Para que funcione debe implementarse attr_accesor en los atributos
=begin
        # Constructor de copia
        def self.newCopy(station)
            newStation = new(station.name, SuppliesPackage.new(station.ammoPower, station.fuelUnits, station.shieldPower))

            newStation.nMedals = station.nMedals;
            
            if station.pendingDamage != nil
                newStation.pendingDamage = station.pendingDamage.copy
            end
            if station.hangar != nil
                newStation.hangar = station.hangar.clone
            end
            if station.weapons != nil
                newStation.weapons = station.weapons.clone
            end
            if station.shieldBoosters != nil
                newStation.shieldBoosters = station.shieldBoosters.clone
            end
        end
=end

        # Copia con referencias los datos de la estación recivida a la actual
        # Necesario para initialize en SpaceCity
        def cloneStation(station)
            @ammoPower = station.ammoPower
            @fuelUnits = station.fuelUnits
            @shieldPower = station.shieldPower
            @name = station.name
            @nMedals = station.nMedals
            @pendingDamage = station.pendingDamage
            @hangar = station.hangar
            @weapons = station.weapons
            @shieldBoosters = station.shieldBoosters
        end

        # Fija la cantidad de combustible al valor pasado como parámetro sin
        # que nunca se exceda del límite
        def assignFuelValue(f)
            if f < MAXFUEL
                @fuelUnits = f
            else
                @fuelUnits = MAXFUEL
            end
        end
        
        # Si el daño pendiente (pendingDamage) no tiene efecto fija la
        # referencia al mismo a null
        def cleanPendingDamage
            if @pendingDamage != nil && @pendingDamage.hasNoEffect
                @pendingDamage = nil
            end
        end

        private :assignFuelValue, :cleanPendingDamage

        # Getters
        attr_reader :ammoPower, :fuelUnits, :shieldPower, :name, :nMedals, :pendingDamage, :hangar, :weapons, :shieldBoosters


        # Devuelve la velocidad de la estación espacial. Esta se calcula como la 
        # fracción entre las unidades de combustible de las que dispone en la 
        # actualidad la estación espacial respecto al máximo unidades de 
        # combustible que es posible almacenar. La velocidad se representa por 
        # tanto como un número del intervalo [0,1]
        def speed
            @fuelUnits / MAXFUEL
        end
        
        def getUIversion
            SpaceStationToUI.new(self)
        end 
        
        #***********************Discarders***********************
        
        # Fija la referencia del hangar a null 
        # para indicar que no se dispone del mismo
        def discardHangar
            @hangar = nil
        end
        
        # Si se dispone de hangar, se solicita al mismo descartar el
        # potenciador de escudo con índice i
        def discardShieldBoosterInHangar(i)
            if @hangar != nil
                @hangar.removeShieldBooster(i)
            end
        end
    
        
        # Si se dispone de hangar, se solicita al mismo descartar el arma
        # con índice i
        def discardWeaponInHangar(i)
            if @hangar != nil
                @hangar.removeWeapon(i)
            end
        end
        
        #***********************Mounters/unmounters***********************
        
        # Eliminar todas las armas y los potenciadores de escudo montados a
        # las que no les queden usos
        def cleanUpMountedItems
            @weapons = @weapons.select {|currWeapon| currWeapon.uses > 0}
            @shieldBoosters = @shieldBoosters.select {|currShield| currShield.uses > 0}
        end
        
        # Se intenta montar el potenciador de escudo con el índice i dentro
        # del hangar. Si se dispone de hangar, se le indica que elimine el 
        # potenciador de escudo de esa posición y si esta operación tiene éxito 
        # (el hangar proporciona el potenciador), se añade el mismo a
        # la colección de potenciadores en uso
        def mountShieldBooster(i)
            if @hangar != nil
                newShield = @hangar.removeShieldBooster(i)
                if newShield != nil
                    @shieldBoosters.push(newShield)
                end
            end
        end
        
        # Se intenta montar el arma con el índice i dentro del hangar. Si se 
        # dispone de hangar, se le indica que elimine el arma de esa posición 
        # y si esta operación tiene éxito (el hangar proporciona el arma), 
        # se añade el arma a la colección de armas en uso
        def mountWeapon(i)
            if @hangar != nil
                newWeapon = @hangar.removeWeapon(i)
                if newWeapon != nil
                    @weapons.push(newWeapon)
                end
            end
        end
        
        #***********************Receivers***********************
        
        # Si no se dispone de hangar, el parámetro pasa a ser el hangar de
        # la estación espacial. Si ya se dispone de 
        # hangar esta operación no tiene efecto
        def receiveHangar(h)
            if @hangar == nil
                @hangar = h
            end
        end
        
        # Si se dispone de hangar, devuelve el resultado de intentar añadir el 
        # potenciador de escudo al mismo. Si no se dispone de hangar devuelve false
        def receiveShieldBooster(s)
            if @hangar != nil
                @hangar.addShieldBooster(s)
            else
                false
            end
        end
        
        # La potencia de disparo, la del escudo y las unidades de combustible
        # se incrementan con el contenido del paquete de suministro
        def receiveSupplies(s)
            @ammoPower += s.ammoPower
            @shieldPower += s.shieldPower
            assignFuelValue(@fuelUnits + s.fuelUnits)
        end
        
        # Si se dispone de hangar, devuelve el resultado de intentar
        # añadir el arma al mismo. Si no se dispone de hangar devuelve false    
        def receiveWeapon(w)
            if @hangar != nil
                @hangar.addWeapon(w)
            else
                false
            end
        end
        
        # Decremento de unidades de combustible disponibles a causa de un 
        # desplazamiento. Al número de las unidades almacenadas se les resta una 
        # fracción de las mismas que es igual a la velocidad de la estación. 
        # Las unidades de combustible no pueden ser inferiores a 0
        def move
            @fuelUnits -= @fuelUnits*speed
            if @fuelUnits < 0
                @fuelUnits = 0
            end
        end    
        
        # Se calcula el parámetro ajustado (adjust) a la lista de armas y
        # potenciadores de escudo de la estación y se almacena 
        # el resultado en el atributo correspondiente.
        def setPendingDamage(d)
            @pendingDamage = d.adjust(@weapons, @shieldBoosters)
        end
        
        # Devuelve true si la estación espacial está en un estado válido. 
        # Eso implica que o bien no se tiene ningún daño pendiente 
        # o que este no tiene efecto
        def validState
            if @pendingDamage == nil
                true
            else
                @pendingDamage.hasNoEffect
            end
        end
        
        # Método de testeo
        def to_s
            getUIversion.to_s
        end
        
        # Realiza las operaciones relacionadas con la recepción del impacto de 
        # un disparo enemigo. Ello implica decrementar la potencia del escudo 
        # en función de la energía del disparo recibido como parámetro y 
        # devolver el resultado de si se ha resistido el disparo o no.
        def receiveShot(shot)
            myProtection = protection
            if myProtection >= shot
                @shieldPower -= SHIELDLOSSPERUNITSHOT * shot;
                if @shieldPower < 0.0
                    @shieldPower = 0.0
                end
                ShotResult::RESIST
            else
                @shieldPower = 0.0
                ShotResult::DONOTRESIST
            end
        end

        # Recepción de un botín. Por cada elemento que indique el botín (pasado
        # como parámetro) se le pide a CardDealer un elemento de ese tipo y se 
        # intenta almacenar con el método receive*() correspondiente. Para las 
        # medallas, simplemente se incrementa su número según lo que indique el botín.                
        # Devuelve la transformación que sufrirá la estación espacial
        # @return Transformation transformation
        def setLoot(loot)
            dealer = CardDealer.instance
            
            h = loot.nHangars
            if h > 0
                hangar = dealer.nextHangar
                receiveHangar(hangar)
            end

            elements = loot.nSupplies
            for i in 1..elements
                mySupply = dealer.nextSuppliesPackage
                receiveSupplies(mySupply)
            end

            elements = loot.nWeapons
            for i in 1..elements
                myWeapon = dealer.nextWeapon
                receiveWeapon(myWeapon)
            end

            elements = loot.nShields
            for i in 1..elements
                myShield = dealer.nextShieldBooster
                receiveShieldBooster(myShield)
            end

            medals = loot.nMedals
            @nMedals += medals

            if loot.efficient
                return Transformation::GETEFFICIENT
            elsif loot.spaceCity
                return Transformation::SPACECITY
            else
                return Transformation::NOTRANSFORM
            end
        end

        # Realiza un disparo y se devuelve la energía o potencia del mismo. 
        # Para ello se multiplica la potencia de disparo por los factores 
        # potenciadores proporcionados por todas las armas.
        def fire
            factor = 1.0
            @weapons.each do |w|
                factor *= w.useIt
            end
            @ammoPower * factor
        end

        # Se usa el escudo de protección y se devuelve la energía del mismo. 
        # Para ello se multiplica la potencia del escudo por los factores 
        # potenciadores proporcionados por todos los potenciadores de 
        # escudos de los que se dispone.
        def protection
            factor = 1.0
            @shieldBoosters.each do |sh|
                factor *= sh.useIt
            end
            @shieldPower * factor
        end

        # Se intenta descartar el potenciador de escudo con índice i de la
        # colección de potenciadores de escudo en uso. Además de perder el 
        # potenciador de escudo, se debe actualizar el daño pendiente 
        # (pendingDamage) si es que se tiene alguno.
        def discardShieldBooster(i)
            size = @shieldBoosters.length
            if i >= 0 && i < size
                s = @shieldBoosters.delete_at(i)
                if @pendingDamage != nil
                    @pendingDamage.discardShieldBooster
                    cleanPendingDamage
                end
            end
        end

        # Se intenta descartar el arma con índice i de la colección de armas en uso.
        # Además de perder el arma, se debe actualizar el daño pendiente 
        # (pendingDamage) si es que se tiene alguno.
        def discardWeapon(i)
            size = @weapons.length
            if i >= 0 && i < size
                w = @weapons.delete_at(i)
                if @pendingDamage != nil
                    @pendingDamage.discardWeapon(w)
                    cleanPendingDamage
                end
            end
        end
    end
end