#encoding: utf-8

require_relative 'GameStateController'
require_relative 'Dice'
require_relative 'Loot'
require_relative 'ShotResult'
require_relative 'GameCharacter'
require_relative 'EnemyStarShip'
require_relative 'SpaceStation'
require_relative 'GameUniverseToUI'
require_relative 'CombatResult'
require_relative 'CardDealer'
require_relative 'Transformation'
require_relative 'PowerEfficientSpaceStation'
require_relative 'BetaPowerEfficientSpaceStation'
require_relative 'SpaceCity'

module Deepspace
    class GameUniverse

        WIN = 10;
    
        def initialize
            @currentStationIndex = -1;
            @turns = 0;
            @gameState = GameStateController.new
            @dice = Dice.new
            @currentEnemy = nil
            @currentStation = nil
            @spaceStations = []
            @haveSpaceCity = false
        end
        
        # Getters
        
        def state
            @gameState.state
        end 
        
        def getUIversion
            GameUniverseToUI.new(@currentStation, @currentEnemy)
        end
        
        # ***********************Discarders***********************
        
        def discardHangar
            if state == GameState::INIT || state == GameState::AFTERCOMBAT
                @currentStation.discardHangar
            end
        end
        
        def discardShieldBooster(i)
            if state == GameState::INIT || state == GameState::AFTERCOMBAT
                @currentStation.discardShieldBooster(i)
            end
        end
        
        def discardShieldBoosterInHangar(i)
            if state == GameState::INIT || state == GameState::AFTERCOMBAT
                @currentStation.discardShieldBoosterInHangar(i)
            end
        end
        
        def discardWeapon(i)
            if state == GameState::INIT || state == GameState::AFTERCOMBAT
                @currentStation.discardWeapon(i)
            end
        end
        
        def discardWeaponInHangar(i)
            if state == GameState::INIT || state == GameState::AFTERCOMBAT  
                @currentStation.discardWeaponInHangar(i)
            end
        end
        
        # ***********************Mounters***********************
    
        def mountShieldBooster(i)
            if state == GameState::INIT || state == GameState::AFTERCOMBAT
                @currentStation.mountShieldBooster(i)
            end
        end
        
        def mountWeapon(i)
            if state == GameState::INIT || state == GameState::AFTERCOMBAT
                @currentStation.mountWeapon(i)
            end
        end
        
        # Devuelve true si la estación espacial que tiene el turno ha llegado al
        # número de medallas necesarias para ganar
        def haveAWinner
            if @currentStation != nil && @currentStation.nMedals >= WIN
                true
            else
                false
            end
        end
        
        # Método de testeo
        def to_s
            out = "currentStationIndex: #{@currentStationIndex}, turns: #{@turns}, "
            out += "gameState: #{@gameState}, dice: #{@dice}, currentEnemy: #{@currentEnemy}, "
            out += "currentStation: #{@currentStation}, spaceStations: #{@spaceStations.join(", ")}"
            out
        end
        
        
        # Este método inicia una partida. Recibe una colección con los
        # nombres de los jugadores. Para cada jugador, se crea una estación
        # espacial y se equipa con suministros, hangares, armas y potenciadores
        # de escudos tomados de los mazos de cartas correspondientes. Se sortea
        # qué jugador comienza la partida, se establece el primer enemigo y
        # comienza el primer turno.
        # @param ArrayList<String> names
        # @return void
        def init(names)
            if @gameState.state == GameState::CANNOTPLAY
                dealer = CardDealer.instance

                names.each do |name|
                    # Crea SuppliesPackage, SpaceStation con este y la añade
                    supplies = dealer.nextSuppliesPackage
                    station = SpaceStation.new(name, supplies)
                    @spaceStations.push(station)
                    # Nº de elementos con los que empieza
                    nh = @dice.initWithNHangars
                    nw = @dice.initWithNWeapons
                    ns = @dice.initWithNShields
                    
                    lo = Loot.new(0,nw,ns,nh,0)
                    station.setLoot(lo)
                end
                
                @currentStationIndex = @dice.whoStarts(names.length)
                @currentStation = @spaceStations[@currentStationIndex]
                @currentEnemy = dealer.nextEnemy
                
                @gameState.next(@turns, @spaceStations.length)
            end
        end    
        
        # Se comprueba que el jugador actual no tiene ningún daño pendiente de
        # cumplir, en cuyo caso se realiza un cambio de turno al siguiente
        # jugador con un nuevo enemigo con quien combatir, devolviendo true.
        # Se devuelve false en otro caso.
        # @return boolean
        def nextTurn
            if @gameState.state == GameState::AFTERCOMBAT
                stationState = @currentStation.validState

                if stationState
                    @currentStationIndex=(@currentStationIndex+1) % @spaceStations.length
                    @turns+=1
                    
                    @currentStation = @spaceStations[@currentStationIndex]
                    @currentStation.cleanUpMountedItems
                    dealer = CardDealer.instance
                    @currentEnemy = dealer.nextEnemy
                    @gameState.next(@turns, @spaceStations.length)
                    
                    return true
                end
                return false
            end
            return false
        end
        
        # Se realiza un combate entre la estación espacial y el enemigo que se
        # reciben como parámetros. Se sigue el procedimiento descrito en las
        # reglas del juego: sorteo de quién dispara primero, posibilidad de
        # escapar, asignación del botín, anotación del daño pendiente, etc.
        # Se devuelve el resultado del combate.
        # @param SpaceStation station
        # @param EnemyStarShip enemy
        # @return CombatResult combatResult
        def combatGo(station, enemy)
            ch = @dice.firstShot
            
            if ch==GameCharacter::ENEMYSTARSHIP
                fire = enemy.fire
                result = station.receiveShot(fire)
                
                if result == ShotResult::RESIST
                    fire = station.fire
                    result = enemy.receiveShot(fire)
                    enemyWins = (result==ShotResult::RESIST)
                else
                    enemyWins = true
                end
            else
                fire = station.fire
                result = enemy.receiveShot(fire)
                enemyWins = (result==ShotResult::RESIST)
            end
            
            
            if enemyWins
                s = station.speed
                moves = @dice.spaceStationMoves(s)
                
                if !moves
                    damage = enemy.damage
                    station.setPendingDamage(damage)
                    combatResult = CombatResult::ENEMYWINS
                else
                    station.move
                    combatResult = CombatResult::STATIONESCAPES
                end
            else
                aLoot = enemy.loot
                trans = station.setLoot(aLoot)
                combatResult = CombatResult::STATIONWINSANDCONVERTS
                if trans == Transformation::GETEFFICIENT
                    makeStationEfficient
                elsif trans == Transformation::SPACECITY
                    createSpaceCity
                else
                    combatResult = CombatResult::STATIONWINS    
                end
                
            end
            
            @gameState.next(@turns, @spaceStations.length)
            return combatResult
        end
        
        # Si la aplicación se encuentra en un estado en donde el combatir está
        # permitido, se realiza un combate entre la estación espacial que tiene el
        # turno y el enemigo actual. Se devuelve el resultado del combate.
        # @return CombatResult combatResult
        def combat
            if @gameState.state==GameState::BEFORECOMBAT || @gameState.state==GameState::INIT
                combatGo(@currentStation, @currentEnemy)
            else
                CombatResult::NOCOMBAT
            end
        end

        # Pregunta al dado si debe convertir la estación espacial actual en una
        # estación eficiente o en una estación eficiente beta. El dado es el que 
        # determina la conversión en un tipo o en otro con el método 
        # extraEfficiency(). Actualiza la referencia a currentStation.
        def makeStationEfficient
            if @dice.extraEfficiency
                @currentStation = BetaPowerEfficientSpaceStation.new(@currentStation)
            else
                @currentStation = PowerEfficientSpaceStation.new(@currentStation)
            end
            @spaceStations[@currentStationIndex] = @currentStation
        end
        
        # Si el juego no dispone ya de una ciudad espacial (haveSpaceCity==false)
        # convierte la estación espacial actual en una ciudad espacial usando 
        # como estación espacial base la actual y como colaboradoras el resto 
        # las estaciones espaciales. Actualiza la referencia a
        # currentStation y también el atributo haveSpaceCity.
        def createSpaceCity
            if !@haveSpaceCity
                collaborators = @spaceStations.clone
                collaborators.delete_at(@currentStationIndex)
                @currentStation = SpaceCity.new(@currentStation, collaborators)
                @spaceStations[@currentStationIndex] = @currentStation
                @haveSpaceCity = true
            end
        end

        private :makeStationEfficient, :createSpaceCity
    end
end