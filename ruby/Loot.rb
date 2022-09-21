# Representa el botín obtenido al vencer a una nave enemiga

require_relative 'LootToUI'

module Deepspace
    class Loot
        def initialize(initNSupplies, initNWeapons, initNShields, initNHangars, initNMedals, ef=false, city=false)
            @nSupplies = initNSupplies
            @nWeapons = initNWeapons
            @nShields = initNShields
            @nHangars = initNHangars
            @nMedals = initNMedals
            @efficient = ef
            @spaceCity = city
        end

        attr_reader :nSupplies, :nWeapons, :nShields, :nHangars, :nMedals, :efficient, :spaceCity

        def getUIversion
            LootToUI.new(self)
        end

        def to_s
            "nSupplies: #@nSupplies, nWeapons: #@nWeapons, nShields: #@nShields, \
            nHangars: #@nHangars, nMedals: #@nMedals, \
            efficient: #@efficient, spaceCity: #@spaceCity";
        end
    end
end