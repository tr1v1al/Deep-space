require_relative 'Damage'
require_relative 'NumericDamageToUI'

module Deepspace
    class NumericDamage < Damage
        def initialize(w, s)
            super(s)
            @nWeapons = w
        end

        def copy
            self.class.new(@nWeapons, @nShields)
        end

        # Devuelve una versión ajustada del objeto a las colecciones de armas y
        # potenciadores de escudos suministradas como parámetro.
        # Partiendo del daño representado por el objeto que recibe este mensaje,
        # se devuelve una copia del mismo pero reducida si es necesario para que
        # no implique perder armas o potenciadores de escudos que no están en
        # las colecciones de los parámetros
        # @param Array<Weapon> w
        # @param Array<ShieldBooster> s
        # @return Damage damage
        def adjust (w, s)
            self.class.new([@nWeapons, w.length].min, super(s))
        end

        # Decrementa en una unidad el contador de armas que deben ser eliminadas.
        # Ese contador no puede ser inferior a cero en ningún caso
        # @param Weapon w
        def discardWeapon(w)
            if @nWeapons > 0
                @nWeapons -= 1
            end
        end

        # Devuelve true si el daño representado no tiene ningún efecto. Esto
        # quiere decir que no implica la pérdida de ningún tipo de accesorio
        # (armas o potenciadores de escudo)
        # @return boolean
        def hasNoEffect
            super && @nWeapons==0
        end


        # Métodos get
        attr_reader :nWeapons


        def getUIversion
            NumericDamageToUI.new(self)
        end
        
        # Representación del objeto en String
        def to_s
            super + ", nWeapons: #{@nWeapons}"
        end

        public_class_method :new
    end
end