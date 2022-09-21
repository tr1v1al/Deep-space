# Representa a las armas delas que puede disponer una estación espacial
# para potenciar su energía al disparar

require_relative 'WeaponType'
require_relative 'WeaponToUI'

module Deepspace
    class Weapon
        def initialize(initName,initType,initUses)
            @name = initName
            @type = initType
            @uses = initUses
        end

        def self.newCopy(other)
            new(other.name, other.type, other.uses)
        end
        
        def name
            @name
        end

        def type
            @type
        end

        def uses
            @uses
        end

        def power
            @type.power
        end

        def useIt
            if @uses > 0
                @uses -= 1
                power
            else
                1.0
            end
        end

        def getUIversion
            WeaponToUI.new(self)
        end

        def to_s
            "Type: #{@name}, Power: #{@type.power}, Uses: #{@uses}"
        end
    end
end