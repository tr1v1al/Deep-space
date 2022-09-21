package deepspace;

import java.util.ArrayList;
import java.util.Iterator;

public class GameUniverse {

    private static final int WIN = 10;
    private int currentStationIndex;
    private int turns;
    private GameStateController gameState;
    private Dice dice;
    private EnemyStarShip currentEnemy;
    private SpaceStation currentStation;
    private ArrayList<SpaceStation> spaceStations;
    private boolean haveSpaceCity;


    public GameUniverse() {
        currentStationIndex = -1;
        turns = 0;
        gameState = new GameStateController();
        dice = new Dice();
        currentEnemy = null;
        currentStation = null;
        spaceStations = new ArrayList<SpaceStation>();
    }
    
    // ***********************Getters***********************
    
    public GameState getState() {
        return gameState.getState();
    }
    
    public GameUniverseToUI getUIversion() {
        return new GameUniverseToUI(currentStation, currentEnemy);
    }    
    
    // ***********************Discarders***********************
    
    public void discardHangar() {
        if (gameState.getState() == GameState.INIT 
                || gameState.getState() == GameState.AFTERCOMBAT)
            currentStation.discardHangar();
            
    }
    
    public void discardShieldBooster(int i) {
        if (gameState.getState() == GameState.INIT 
                || gameState.getState() == GameState.AFTERCOMBAT) 
            currentStation.discardShieldBooster(i);
    }
    
    public void discardShieldBoosterInHangar(int i) {
        if (gameState.getState() == GameState.INIT 
                || gameState.getState() == GameState.AFTERCOMBAT)
            currentStation.discardShieldBoosterInHangar(i);
    }
    
    public void discardWeapon(int i) {
        if (gameState.getState() == GameState.INIT 
                || gameState.getState() == GameState.AFTERCOMBAT)
            currentStation.discardWeapon(i);
    }
    
    public void discardWeaponInHangar(int i) {
        if (gameState.getState() == GameState.INIT 
                || gameState.getState() == GameState.AFTERCOMBAT)    
            currentStation.discardWeaponInHangar(i);
    }
    
    // ***********************Mounters***********************
    

    
    public void mountShieldBooster(int i) {
        if (gameState.getState() == GameState.INIT 
                || gameState.getState() == GameState.AFTERCOMBAT)
            currentStation.mountShieldBooster(i);
    }
    
    public void mountWeapon(int i) {
        if (gameState.getState() == GameState.INIT 
                || gameState.getState() == GameState.AFTERCOMBAT)
            currentStation.mountWeapon(i);
    }
    
    // Devuelve true si la estación espacial que tiene el turno ha llegado al
    // número de medallas necesarias para ganar
    public boolean haveAWinner() {
        if (currentStation != null && currentStation.getNMedals() >= WIN)
            return true;
        else
            return false;
    }    
    
    // Método de testeo
    public String toString() {
        String currEnemStr = 
                (currentEnemy == null) ? "null": currentEnemy.toString();
        String currStatStr = 
                (currentStation == null) ? "null": currentStation.toString();
        return "currentStationIndex: " + currentStationIndex + ", turns: " + 
                turns + ", gameState: " + gameState.getState() + ", dice: " + 
                dice.toString() + ", currentEnemy: " + currEnemStr + 
                ", currentStation: " + currStatStr + 
                ", spaceStations: " + spaceStations.toString();
    }    
    
    
    // Este método inicia una partida. Recibe una colección con los
    // nombres de los jugadores. Para cada jugador, se crea una estación
    // espacial y se equipa con suministros, hangares, armas y potenciadores
    // de escudos tomados de los mazos de cartas correspondientes. Se sortea
    // qué jugador comienza la partida, se establece el primer enemigo y
    // comienza el primer turno.
    // @param ArrayList<String> names
    // @return void
    public void init(ArrayList<String> names) {
        if (gameState.getState()==GameState.CANNOTPLAY){
            CardDealer dealer = CardDealer.getInstance();
            
            Iterator<String> it = names.iterator();
            while(it.hasNext()){
                // Crea SuppliesPackage, SpaceStation con este y la añade
                SuppliesPackage supplies=new SuppliesPackage(dealer.nextSuppliesPackage());
                SpaceStation station = new SpaceStation(it.next(), supplies);
                spaceStations.add(station);
                
                // Nº de elementos con los que empieza
                int nh = dice.initWithNHangars();
                int nw = dice.initWithNWeapons();
                int ns = dice.initWithNShields();
                
                Loot lo = new Loot(0,nw,ns,nh,0);
                station.setLoot(lo);
            }
            
            currentStationIndex = dice.whoStarts(names.size());
            currentStation = spaceStations.get(currentStationIndex);
            currentEnemy = dealer.nextEnemy();
            
            gameState.next(turns, spaceStations.size());
        }
    }    
    
    // Se comprueba que el jugador actual no tiene ningún daño pendiente de
    // cumplir, en cuyo caso se realiza un cambio de turno al siguiente
    // jugador con un nuevo enemigo con quien combatir, devolviendo true.
    // Se devuelve false en otro caso.
    // @return boolean
    public boolean nextTurn() {
        if (gameState.getState() == GameState.AFTERCOMBAT){
            boolean stationState = currentStation.validState();
            
            if (stationState){
                currentStationIndex=(currentStationIndex+1)%spaceStations.size();
                turns++;
                
                currentStation = spaceStations.get(currentStationIndex);
                currentStation.cleanUpMountedItems();
                CardDealer dealer = CardDealer.getInstance();
                currentEnemy = dealer.nextEnemy();
                gameState.next(turns, spaceStations.size());
                
                return true;
            }
            return false;
        }
        return false;
    }    
    
    // Se realiza un combate entre la estación espacial y el enemigo que se
    // reciben como parámetros. Se sigue el procedimiento descrito en las
    // reglas del juego: sorteo de quién dispara primero, posibilidad de
    // escapar, asignación del botín, anotación del daño pendiente, etc.
    // Se devuelve el resultado del combate.
    // @param SpaceStation station
    // @param EnemyStarShip enemy
    // @return CombatResult combatResult
    CombatResult combat(SpaceStation station, EnemyStarShip enemy) {
        GameCharacter ch = dice.firstShot();
        boolean enemyWins;
        CombatResult combatResult;
        
        if (ch==GameCharacter.ENEMYSTARSHIP){
            float fire = enemy.fire();
            ShotResult result = station.receiveShot(fire);
            
            if (result == ShotResult.RESIST){
                fire = station.fire();
                result = enemy.receiveShot(fire);
                enemyWins = (result==ShotResult.RESIST);
            } else
                enemyWins = true;
            
        } else{
            float fire = station.fire();
            ShotResult result = enemy.receiveShot(fire);
            enemyWins = (result==ShotResult.RESIST);
        }
        
        
        if (enemyWins){
            float s = station.getSpeed();
            boolean moves = dice.spaceStationMoves(s);
            
            if (!moves){
                Damage damage = enemy.getDamage();
                station.setPendingDamage(damage);
                combatResult = CombatResult.ENEMYWINS;
            } else {
                station.move();
                combatResult = CombatResult.STATIONESCAPES;
            }
        } else {
            Loot aLoot = enemy.getLoot();
            Transformation trans = station.setLoot(aLoot);
            combatResult = CombatResult.STATIONWINSANDCONVERTS;
            if (trans == Transformation.GETEFFICIENT)
                makeStationEfficient();
            else if (trans == Transformation.SPACECITY)
                createSpaceCity();
            else
                combatResult = CombatResult.STATIONWINS;
        }
        
        gameState.next(turns, spaceStations.size());
        return combatResult;
    }
    
    // Si la aplicación se encuentra en un estado en donde el combatir está
    // permitido, se realiza un combate entre la estación espacial que tiene el
    // turno y el enemigo actual. Se devuelve el resultado del combate.
    // @return CombatResult combatResult
    public CombatResult combat() {
        if(gameState.getState() == GameState.BEFORECOMBAT ||
                gameState.getState() == GameState.INIT)
            return combat(currentStation, currentEnemy);
        else
            return CombatResult.NOCOMBAT;
    }
    // Pregunta al dado si debe convertir la estación espacial actual en una
    // estación eficiente o en una estación eficiente beta. El dado es el que 
    // determina la conversión en un tipo o en otro con el método 
    // extraEfficiency(). Actualiza la referencia a currentStation.
    private void makeStationEfficient() {
        if (dice.extraEfficiency())
            currentStation = new BetaPowerEfficientSpaceStation(currentStation);
        else
            currentStation = new PowerEfficientSpaceStation(currentStation);
        spaceStations.set(currentStationIndex, currentStation);
    }
    
    // Si el juego no dispone ya de una ciudad espacial (haveSpaceCity==false)
    // convierte la estación espacial actual en una ciudad espacial usando 
    // como estación espacial base la actual y como colaboradoras el resto 
    // las estaciones espaciales. Actualiza la referencia a
    // currentStation y también el atributo haveSpaceCity.
    private void createSpaceCity() {
        if (!haveSpaceCity) {
            // Los colaboradores son todas las estaciones menos la current
            ArrayList<SpaceStation> collaborators = new ArrayList<>(spaceStations);
            collaborators.remove(currentStationIndex);
            
            // Creamos ciudad espacial
            currentStation = new SpaceCity(currentStation, spaceStations);
            
            // Actualizamos los atributos
            spaceStations.set(currentStationIndex, currentStation);
            haveSpaceCity = true;
        }
    }
}