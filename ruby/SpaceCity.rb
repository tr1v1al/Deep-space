require_relative 'SpaceStation'
require_relative 'SpaceCityToUI'

module Deepspace
    class SpaceCity < SpaceStation
        # @param SpaceStation base
        # @param ArrayList<SpaceStation> rest
        def initialize(base, rest)
            cloneStation(base)
            @base = base
            @collaborators = rest
        end

        attr_reader :collaborators


        # Realiza un disparo y se devuelve la energía o potencia del mismo. 
        # Para ello se multiplica la potencia de disparo por los factores 
        # potenciadores proporcionados por todas las armas y suma la de
        # cada estación.
        def fire
            factor = @base.fire
            
            @collaborators.each do |station|
                factor += station.fire
            end

            factor
        end
        
        # Se usa el escudo de protección y se devuelve la energía del mismo. 
        # Para ello se multiplica la potencia del escudo por los factores 
        # potenciadores proporcionados por todos los potenciadores de 
        # escudos de los que se dispone y suma la de cada estación.
        def protection
            factor = @base.protection
            
            @collaborators.each do |station|
                factor += station.protection
            end

            factor
        end
        
        # Recepción de un botín. 
        # La ciudad espacial no sufrirá ninguna transformación
        # @return Transformation transformation
        def setLoot(loot)
            super
            Transformation::NOTRANSFORM
        end
        
        def to_s
            getUIversion.to_s
        end
        
        def getUIversion
            SpaceCityToUI.new(self)
        end


    end
end