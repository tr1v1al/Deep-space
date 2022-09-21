#encoding: utf-8

require_relative 'SpaceStation'
require_relative 'Transformation'
require_relative 'PowerEfficientSpaceStationToUI'

module Deepspace
    class PowerEfficientSpaceStation < SpaceStation
        EFFICIENCYFACTOR = 1.1
        def initialize(station)
            cloneStation(station)
        end

        def fire
            super * EFFICIENCYFACTOR
        end

        def protection
            super * EFFICIENCYFACTOR
        end

        def setLoot(loot)
            super
            if loot.efficient
                Transformation::GETEFFICIENT
            else
                Transformation::NOTRANSFORM
            end
        end

        def to_s
            "Power efficient space station: " + super
        end
      
          # To UI
        def getUIversion
            PowerEfficientSpaceStationToUI.new(self)
        end
    end
end