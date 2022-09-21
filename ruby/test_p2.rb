#encoding: utf-8

# Main con pruebas de los métodos

require_relative 'CombatResult'
require_relative 'Dice'
require_relative 'GameCharacter'
require_relative 'Loot'
require_relative 'ShieldBooster'
require_relative 'ShotResult'
require_relative 'SuppliesPackage'
require_relative 'Weapon'
require_relative 'WeaponType'
require_relative 'Hangar'
require_relative 'Damage'
require_relative 'EnemyStarShip'
require_relative 'SpaceStation'
require_relative 'GameUniverse'

class TestP2
    def main
        puts "\nto_s"
        puts Deepspace::Dice.new()
        puts Deepspace::Loot.new(1,2,3,4,5)
        puts Deepspace::ShieldBooster.new("theShield",4,5)
        puts Deepspace::SuppliesPackage.new(3.4, 3.5, 3.6)
        puts Deepspace::Weapon.new('theWeapon', Deepspace::WeaponType::LASER, 5)

        puts "\nHangar:\n"
        hangar = Deepspace::Hangar.new(4)
        hangar.addWeapon(Deepspace::Weapon.new('Laser', Deepspace::WeaponType::LASER, 5))
        hangar.addWeapon(Deepspace::Weapon.new('Plasma', Deepspace::WeaponType::PLASMA, 4))
        hangar.addShieldBooster(Deepspace::ShieldBooster.new("shield1",2,3))
        hangar.addShieldBooster(Deepspace::ShieldBooster.new("shield2",4,5))
        puts Deepspace::Hangar.newCopy(hangar)
        puts hangar.maxElements
        hangar2 = Deepspace::Hangar.newCopy(hangar)
        hangar.removeShieldBooster(1)
        hangar.removeWeapon(1)
        puts hangar
        puts hangar2

        puts "\nDamage:\n"
        damage = Deepspace::Damage.newNumericWeapons(2,3)
        puts damage
        weaponTypes = []
        weaponTypes.push(Deepspace::WeaponType::LASER)
        weaponTypes.push(Deepspace::WeaponType::PLASMA)
        damage = Deepspace::Damage.newSpecificWeapons(weaponTypes, 3)
        puts Deepspace::Damage.newCopy(damage)
        puts damage.hasNoEffect

        puts "Adjust method: "
        weapons = []
        weapons.push(Deepspace::Weapon.new("Laser", Deepspace::WeaponType::LASER, 5))
        shields = []
        shields.push(Deepspace::ShieldBooster.new("shield1", 2, 3))
        puts damage.adjust(weapons, shields)

        puts "Discard LASER and one shield: "
        damage.discardShieldBooster
        damage.discardWeapon(Deepspace::Weapon.new("Laser", Deepspace::WeaponType::LASER, 5))
        puts damage

        puts "\nEnemyStarShip:"
        enemyStarShip = Deepspace::EnemyStarShip.new("ship", 2.2, 3.3, Deepspace::Loot.new(1,2,3,4,5), Deepspace::Damage.newNumericWeapons(1,2))
        puts Deepspace::EnemyStarShip.newCopy(enemyStarShip)
        puts enemyStarShip.fire
        puts enemyStarShip.protection
        puts enemyStarShip.receiveShot(3.2)
        puts enemyStarShip.receiveShot(3.4)

        puts "\nSpaceStation:"
        mySupply = Deepspace::SuppliesPackage.new(30,40,50)
        puts "Creating muh space station"
        myStation = Deepspace::SpaceStation.new("Space station 13", mySupply)
        puts "Fast af boi"
        puts "Speed: #{myStation.getSpeed}"
        puts "Creating hangar with stuff"
        myHangar = Deepspace::Hangar.new(4)
        myHangar.addWeapon(Deepspace::Weapon.new("BFG", Deepspace::WeaponType::PLASMA, 100))
        myHangar.addShieldBooster(Deepspace::ShieldBooster.new("HEV charger", 3, 4))
        puts myHangar
        puts "Receive hangar and add stuff to hangar"
        myStation.receiveHangar(myHangar)
        puts myStation.hangar
        myStation.receiveWeapon(Deepspace::Weapon.new("Thot slayer", Deepspace::WeaponType::LASER, 0))
        myStation.receiveShieldBooster(Deepspace::ShieldBooster.new("bruv", 10, 10))
        puts myStation.hangar
        puts "Discard stuff from hangar"
        myStation.discardWeaponInHangar(0)
        myStation.discardShieldBoosterInHangar(0)
        puts myStation.hangar
        puts "Mount stuff"
        myStation.mountWeapon(0)
        myStation.mountShieldBooster(0)
        puts myStation
        puts "Clean up used weapons"
        myStation.cleanUpMountedItems
        puts myStation
        puts "Move it move it"
        myStation.move()
        puts myStation.fuelUnits
        puts "Set pending damage"
        myStation.setPendingDamage(damage)
        puts myStation.pendingDamage
        puts "State is valid : #{myStation.validState}"

        puts "\nGame universe:"
        myUniverse = Deepspace::GameUniverse.new
        puts myUniverse
        
    end
end

test = TestP2.new
puts test.main