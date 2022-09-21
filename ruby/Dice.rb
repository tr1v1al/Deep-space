# Esta clase toma las decisiones que dependen del azar en el juego

require_relative 'GameCharacter'

module Deepspace
    class Dice
        def initialize
            @NHANGARSPROB = 0.25
            @NSHIELDSPROB = 0.25
            @NWEAPONSPROB = 0.33
            @FIRSTSHOTPROB = 0.5
            @EXTRAEFFICIENCYPROB = 0.8
            @generator = Random.new
        end

        def extraEfficiency
            @generator.rand < @EXTRAEFFICIENCYPROB
        end

        # Devuelve el número de hangares que recibirá una estación espacial al
        # ser creada
        def initWithNHangars
            if @generator.rand < @NHANGARSPROB
                0
            else
                1
            end
        end
        
        # Determina el nº de armas que recibirá una estación al ser creada
        def initWithNWeapons
            n = @generator.rand
            if n < @NWEAPONSPROB
                1
            elsif n < 2*@NWEAPONSPROB
                2
            else
                3
            end
        end
        
        # Determina el nº de potenciadores de escudo que reibirá una estación
        # al ser creada
        def initWithNShields
            if @generator.rand < @NSHIELDSPROB
                0
            else
                1
            end
        end
        
        # Determina el índice del jugador que iniciará la partida
        def whoStarts(nPlayers)
            @generator.rand(nPlayers)
        end
        
        # Determina que personaje dispara primero en un combate, la estación
        # espacial o la nave enemiga
        def firstShot
            if @generator.rand < @FIRSTSHOTPROB
                GameCharacter::SPACESTATION
            else
                GameCharacter::ENEMYSTARSHIP
            end
        end
        
        # Determina si la estación espacial se moverá para esquivar el disparo
        # La probabilidad de moverse será mayor cuanto más cerca está la velocidad
        # potencial actual de la estación espacial de su velocidad máxima potencial
        def spaceStationMoves(speed)
            @generator.rand < speed
        end

        def to_s
            "NHANGARSPROB: #@NHANGARSPROB, NSHIELDSPROB: #@NSHIELDSPROB, NWEAPONSPROB: #@NWEAPONSPROB, FIRSTSHOTPROB: #@FIRSTSHOTPROB";
        end
    end
end