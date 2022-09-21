require_relative 'Damage'
require_relative 'SpecificDamageToUI'

module Deepspace
    class SpecificDamage < Damage
        def initialize(wl, s)
            super(s)
            @weapons = wl
        end

        def copy
            self.class.new(@weapons, @nShields)
        end


        # Devuelve el índice de la posición de la primera arma de la colección de
        # armas (primer parámetro) cuyo tipo coincida con el tipo indicado
        # por el segundo parámetro. Devuelve -1 si no hay ninguna arma en la
        # colección del tipo indicado por el segundo parámetro
        # @param Array<Weapon> w
        # @param WeaponType t
        # @return int i
        private def arrayContainsType(w, t)
            i=0
            w.each do |weapon|
                if weapon.type == t
                    return i
                else
                    i+=1
                end
            end
            # No se encontró
            -1
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
            # Damage con array de weapons
            wAux = w.clone
            weaponsResult = []

            @weapons.each do |element|
                pos = arrayContainsType(wAux, element)

                if pos != -1
                    # Si se ha encontrado el elemento, lo añadimos al resultado
                    # y lo borramos de wAux
                    weaponsResult.push(element)
                    wAux.delete_at(pos)
                end
            end

            self.class.new(weaponsResult, super(s))
        end

        # Intenta eliminar el tipo del arma pasada como parámetro de esa lista.
        # @param Weapon w
        def discardWeapon(w)
            if @weapons.length != 0
                pos = @weapons.index(w.type)
                if pos != nil
                    @weapons.delete_at(pos)
                end
            end
        end

        # Devuelve true si el daño representado no tiene ningún efecto. Esto
        # quiere decir que no implica la pérdida de ningún tipo de accesorio
        # (armas o potenciadores de escudo)
        # @return boolean
        def hasNoEffect
            super && @weapons.length==0
        end


        # Métodos get
        attr_reader :weapons


        def getUIversion
            SpecificDamageToUI.new(self)
        end
        
        # Representación del objeto en String
        def to_s
            super + ", weapons: [#{@weapons.join(", ")}]"
        end

        public_class_method :new
    end
end