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

class TestP1
    def main
        puts "\nTesting everything\n"

        puts "\nEnum types:\n\n"

        puts Deepspace::CombatResult::ENEMYWINS
        puts Deepspace::CombatResult::NOCOMBAT
        puts Deepspace::CombatResult::STATIONESCAPES
        puts Deepspace::CombatResult::STATIONWINS
        puts Deepspace::GameCharacter::ENEMYSTARSHIP
        puts Deepspace::GameCharacter::SPACESTATION
        puts Deepspace::ShotResult::DONOTRESIST
        puts Deepspace::ShotResult::RESIST

        puts "\nWeaponType:\n\n"
        puts Deepspace::WeaponType::LASER.power
        puts Deepspace::WeaponType::MISSILE.power
        puts Deepspace::WeaponType::PLASMA.power        
        
        puts "\nLoot:\n\n"
        puts "Test values: 0, 1, 1, 2, 3"
        myLoot = Deepspace::Loot.new(0,1,1,2,3)
        puts myLoot.nSupplies
        puts myLoot.nWeapons
        puts myLoot.nShields
        puts myLoot.nHangars
        puts myLoot.nMedals

        puts "\nSuppliesPackage:\n\n"
        puts "Test values: 2, 2, 8"
        mySupply = Deepspace::SuppliesPackage.new(2, 2, 8)
        copySupply = Deepspace::SuppliesPackage.newCopy(mySupply)
        puts mySupply.ammoPower
        puts mySupply.fuelUnits
        puts mySupply.shieldPower
        puts copySupply.ammoPower
        puts copySupply.fuelUnits
        puts copySupply.shieldPower

        puts "\nShieldBooster:\n\n"
        puts "Test values: Aegis of the Immortal, 2, 1"
        myShield = Deepspace::ShieldBooster.new("Aegis of the Immortal", 2, 1)
        copyShield = Deepspace::ShieldBooster.newCopy(myShield)
        puts myShield.boost
        puts myShield.uses
        puts myShield.useIt
        puts myShield.uses
        puts copyShield.boost
        puts copyShield.uses
        puts copyShield.useIt
        puts copyShield.uses

        puts "\nWeapon:\n\n"
        puts "Test values: Overwatch Standard Issue Pulse Rifle, PLASMA, 90"
        myWeapon = Deepspace::Weapon.new("Overwatch Standard Issue Pulse Rifle", Deepspace::WeaponType::PLASMA, 90)
        copyWeapon = Deepspace::Weapon.newCopy(myWeapon)
        puts myWeapon.type.power
        puts myWeapon.uses
        puts myWeapon.power
        puts myWeapon.useIt
        puts myWeapon.uses
        puts copyWeapon.type.power
        puts copyWeapon.uses
        puts copyWeapon.power
        puts copyWeapon.useIt
        puts copyWeapon.uses

        puts "\nDice:\n\n"
        myDice = Deepspace::Dice.new
        count1 = 0
        count2 = 0
        count3 = 0        

        puts "Testing initWithNHangars:"
        for i in 0..99
            if myDice.initWithNHangars == 0
                count1+=1
            else
                count2+=1
            end
        end
        puts "#{count1} cases with 0 hangars, expected ~25"
        puts "#{count2} cases with 1 hangar, expected ~75" 

        count1 = 0
        count2 = 0

        puts "Testing initWithNWeapons:"
        for i in 0..99
            if myDice.initWithNWeapons == 1
                count1+=1
            elsif myDice.initWithNWeapons == 2
                count2+=1
            else
                count3+=1
            end
        end
        puts "#{count1} cases with 1 weapon, expected ~33"
        puts "#{count2} cases with 2 weapons, expected ~33"
        puts "#{count3} cases with 3 weapons, expected ~33" 

        count1 = 0
        count2 = 0

        puts "Testing initWithNShields:"
        for i in 0..99
            if myDice.initWithNShields == 0
                count1+=1
            else
                count2+=1
            end
        end
        puts "#{count1} cases with 0 shields, expected ~25"
        puts "#{count2} cases with 1 shields, expected ~75" 

        puts "Testing whoStarts:"
        for i in 0..10
            puts myDice.whoStarts(10)
        end

        count1 = 0
        count2 = 0

        puts "Testing firstShot:"
        for i in 0..99
            if myDice.firstShot == Deepspace::GameCharacter::SPACESTATION
                count1+=1
            else
                count2+=1
            end    
        end
        puts "#{count1} cases with SPACESTATION taking first shot, ~50 expected"
        puts "#{count2} cases with ENEMYSTARSHIP taking first shot, ~50 expected"

        count1 = 0
        count2 = 0

        puts "Testing spaceStationMoves:"
        puts "Testing value: 0.5"
        for i in 0..99
            if myDice.spaceStationMoves(0.5) == true
                count1+=1
            else
                count2+=1
            end
        end
        puts "#{count1} cases where space station moved, ~50 expected"
        puts "#{count2} cases where space station did not move, ~50 expected"






        # Otros tests
=begin
        puts "Prueba de métodos y clases:\n\n"

        puts "Enum CombatResult:"
        puts Deepspace::CombatResult::ENEMYWINS
        puts Deepspace::CombatResult::NOCOMBAT
        puts Deepspace::CombatResult::STATIONESCAPES
        puts Deepspace::CombatResult::STATIONWINS

        puts "\n\n"

        puts "Enum GameCharacter:"
        puts Deepspace::GameCharacter::ENEMYSTARSHIP
        puts Deepspace::GameCharacter::SPACESTATION

        puts "\n\n"

        puts "Enum ShotResult:"
        puts Deepspace::ShotResult::DONOTRESIST
        puts Deepspace::ShotResult::RESIST

        puts"\n\n"

        puts "WeaponType:"
        puts Deepspace::WeaponType::LASER.power
        puts Deepspace::WeaponType::MISSILE.power
        puts Deepspace::WeaponType::PLASMA.power

        puts "\n\n"

        puts "Loot:"
        loot = Deepspace::Loot.new(1,2,3,4,5)
        puts loot.nSupplies
        puts loot.nWeapons
        puts loot.nShields
        puts loot.nHangars
        puts loot.nMedals

        puts "\n\n"

        puts "SuppliesPackage:"
        supplies = Deepspace::SuppliesPackage.new(1,2,3)
        puts supplies.ammoPower
        puts supplies.fuelUnits
        puts supplies.shieldPower
        
        puts "\n\n"

        puts "ShieldBooster:"
        shield = Deepspace::ShieldBooster.new("a", 3, 2)
        puts shield.boost
        puts shield.uses
        puts "UseIt:"
        puts shield.useIt
        puts shield.useIt
        puts shield.useIt

        puts "\n\n"
        
        puts "Weapon:"
        weapon1 = Deepspace::Weapon.new("a", Deepspace::WeaponType::LASER, 2)
        weapon = weapon1
        puts weapon.uses
        puts weapon.type.power
        puts weapon.power
        puts "UseIt:"
        puts weapon.useIt
        puts weapon.useIt
        puts weapon.useIt

        puts "\n\n"


        

        puts "Dice:"

        # Variables
        dice = Deepspace::Dice.new
        initWithNHangars=0
        weapon1=0
        weapon2=0
        weapon3=0
        initWithNShields=0
        pl1=0
        pl2=0
        pl3=0
        firstShotSpaceStation=0
        spaceStationMoves=0

        for i in 0...100 do
            if dice.initWithNHangars == 0
                initWithNHangars+=1
            end
            if dice.initWithNShields == 0
                initWithNShields+=1
            end

            weapons = dice.initWithNWeapons
            if weapons == 1
                weapon1+=1
            else
                if weapons == 2
                    weapon2+=1
                else
                    weapon3+=1
                end
            end

            pl = dice.whoStarts(3)
            if pl == 1
                pl1+=1
            else
                if pl == 2
                    pl2+=1
                else
                    pl3+=1
                end
            end

            if dice.firstShot == Deepspace::GameCharacter::SPACESTATION
                firstShotSpaceStation+=1
            end

            if dice.spaceStationMoves(0.40)
                spaceStationMoves+=1
            end
        end



        puts "initWithNHangars: " + initWithNHangars.to_s
        puts "1 weapon: " + weapon1.to_s
        puts "2 weapons: " + weapon2.to_s
        puts "3 weapons: " + weapon3.to_s
        puts "initWithNShields: " + initWithNShields.to_s
        puts "player 1: " + pl1.to_s
        puts "player 2: " + pl2.to_s
        puts "player 3: " + pl3.to_s
        puts "firstShotSpaceStation: " + firstShotSpaceStation.to_s
        puts "spaceStationMoves: " + spaceStationMoves.to_s
=end

    end
end


test = TestP1.new
puts test.main