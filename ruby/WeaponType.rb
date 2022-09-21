# Representa los tipos de armas del juego, con una potencia de disparo asociada

module Deepspace
    module WeaponType
        class Type
            def initialize(initPower, initName)
                @power = initPower
                @name = initName
            end

            attr_reader :power, :name

            def to_s
                "#@name"
            end
        end

        LASER = Type.new(2.0, :LASER)
        MISSILE = Type.new(3.0, :MISSILE)
        PLASMA = Type.new(4.0, :PLASMA)
    end
end