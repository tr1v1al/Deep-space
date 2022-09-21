require_relative 'Loot'
require_relative 'Damage'
require_relative 'ShotResult'
require_relative 'EnemyToUI'

module Deepspace
    class EnemyStarShip
        # Constructor
        # @param String n
        # @param float a
        # @param float s
        # @param Loot l
        # @param Damage d
        def initialize(n, a, s, l, d)
            @name = n
            @ammoPower = a
            @shieldPower = s
            @loot = l
            @damage = d
        end

        def self.newCopy(e)
            new(e.name, e.ammoPower, e.shieldPower, e.loot, e.damage)
        end

        # Get
        attr_reader :ammoPower, :damage, :loot, :name, :shieldPower
        
        
        # Devuelve el nivel de energía de disparo de la nave enemiga (ammoPower)
        # @return float ammoPower
        def fire
            @ammoPower
        end

        # Devuelve el nivel de energía del escudo de la nave enemiga (shieldPower)
        # @return float shieldPower
        def protection
            @shieldPower
        end

        # Devuelve el resultado que se produce al recibir un disparo de una
        # determinada potencia (pasada como parámetro). Si el nivel de la
        # protección de los escudos es menor que la intensidad del disparo, la
        # nave enemiga no resiste (DONOTRESIST). En caso contrario resiste el
        # disparo (RESIST). Se devuelve el resultado producido por el disparo
        # recibido.
        # @param float shot
        # @return ShotResult result
        def receiveShot(shot)
            if @shieldPower < shot
                ShotResult::DONOTRESIST
            else
                ShotResult::RESIST
            end
        end
        
        def getUIversion
            EnemyToUI.new(self)
        end

        def to_s
            "name: #@name, ammoPower: #@ammoPower, shieldPower: #@shieldPower, loot: (#@loot), damage: (#@damage)";
        end
    end
end