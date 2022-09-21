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
require_relative 'SpaceCity'
require_relative 'PowerEfficientSpaceStation'
require_relative 'BetaPowerEfficientSpaceStation'

class TestP4
    def main
        puts "\nSpaceStation:"
        myStation = Deepspace::SpaceStation.new("Space station 13", Deepspace::SuppliesPackage.new(30,40,50))
        myHangar = Deepspace::Hangar.new(4)
        myHangar.addWeapon(Deepspace::Weapon.new("BFG", Deepspace::WeaponType::PLASMA, 100))
        myHangar.addShieldBooster(Deepspace::ShieldBooster.new("HEV charger", 3, 4))
        myStation.receiveHangar(myHangar)
        myStation.receiveWeapon(Deepspace::Weapon.new("Thot slayer", Deepspace::WeaponType::LASER, 0))
        myStation.receiveShieldBooster(Deepspace::ShieldBooster.new("bruv", 10, 10))
        
        #puts myStation.inspect + "\n\n"
        #puts myStation.clone.inspect + "\n\n"
        #puts Deepspace::SpaceStation.newCopy(myStation).inspect + "\n\n"
        puts myStation.setLoot(Deepspace::Loot.new(1,2,3,4,5,true,true))



        puts "\n\nDamage:\n"
        numericDamage = Deepspace::NumericDamage.new(2,3)
        puts numericDamage.copy
        
        weaponTypes = []
        weaponTypes.push(Deepspace::WeaponType::LASER)
        weaponTypes.push(Deepspace::WeaponType::PLASMA)
        specificDamage = Deepspace::SpecificDamage.new(weaponTypes,3)
        puts specificDamage.copy

        numericDamage.discardShieldBooster
        specificDamage.discardShieldBooster
        puts numericDamage; puts specificDamage
        puts numericDamage.hasNoEffect; puts specificDamage.hasNoEffect
        numericDamage.discardWeapon(Deepspace::Weapon.new('Laser', Deepspace::WeaponType::LASER, 5))
        specificDamage.discardWeapon(Deepspace::Weapon.new('Laser', Deepspace::WeaponType::LASER, 5))
        puts numericDamage; puts specificDamage


        puts "\n\nSpaceCity:"
        station1 = Deepspace::SpaceStation.new("s1", Deepspace::SuppliesPackage.new(30,40,50))
        station2 = Deepspace::SpaceStation.new("s2", Deepspace::SuppliesPackage.new(2,3,4))
        station3 = Deepspace::SpaceStation.new("s2", Deepspace::SuppliesPackage.new(3,4,5))
        station4 = Deepspace::SpaceStation.new("s2", Deepspace::SuppliesPackage.new(4,5,6))
        stations = []
        stations.push(station2); stations.push(station3); stations.push(station4)
        spaceCity = Deepspace::SpaceCity.new(station1, stations)
        puts spaceCity.fire
        puts spaceCity.protection
        puts spaceCity.setLoot(Deepspace::Loot.new(1,2,3,4,5,true,true))

    end
end

test = TestP4.new
puts test.main