module Stattleship
  module Params
    class StatLeadersParams < Stattleship::Params::QueryParams
      attr_accessor :place, :stat, :type

      private

      def params
        {
          'stat' => stat,
          'type' => type,
          'place' => place
        }
      end
    end
  end
end
