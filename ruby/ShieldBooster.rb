# Representa a los potenciadores de escudo que pueden tener las estaciones
# espaciales

require_relative 'ShieldToUI'

module Deepspace
    class ShieldBooster
        def initialize(initName, initBoost, initUses)
            @name = initName
            @boost = initBoost
            @uses = initUses
        end

        # Constructor de copia
        def self.newCopy(other)
            new(other.name, other.boost, other.uses)
        end

        def name
            @name
        end

        def boost
            @boost
        end

        def uses
            @uses
        end

        def useIt
            if @uses > 0
                @uses-=1
                @boost
            else
                1.0
            end
        end

        def getUIversion
            ShieldToUI.new(self)
        end

        def to_s
            "name: #@name, boost: #@boost, uses: #@uses";
        end
    end
end