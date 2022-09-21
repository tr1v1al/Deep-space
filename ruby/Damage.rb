require_relative 'WeaponType'
require_relative 'Weapon'
require_relative 'DamageToUI'

module Deepspace
    class Damage
        def initialize(s)
            @nShields = s
        end

        # Devuelve el nº de escudos ajustado a las colección de
        # potenciadores de escudos suministrada como parámetro.
        # @param Array<ShieldBooster> s
        # @return Int nShieldsNew
        def adjust (s)
            [s.length, @nShields].min
        end

        # Decrementa en una unidad el número de potenciadores de escudo que
        # deben ser eliminados. Ese contador no puede ser inferior a cero
        # en ningún caso
        def discardShieldBooster
            if @nShields > 0
                @nShields -= 1
            end
        end

        # Devuelve true si el daño representado no tiene ningún efecto. Esto
        # quiere decir que no implica la pérdida de ningún tipo de accesorio
        # (armas o potenciadores de escudo)
        # @return boolean
        def hasNoEffect
            @nShields==0
        end


        # Métodos get
        attr_reader :nShields


        def getUIversion
            DamageToUI.new(self)
        end
        
        # Representación del objeto en String
        def to_s
            "nShields: #{@nShields}"
        end

        private_class_method :new
    end
end