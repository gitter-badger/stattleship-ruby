require 'spec_helper'

module Stattleship
  module Params
    RSpec.describe FootballTopStatsParams do
      describe '#query' do
        it 'defines a query hash of parameters' do
          params = FootballTopStatsParams.new

          params.stat = 'passes_touchdown'
          params.type = 'football_passing_stat'
          params.place = 6

          query_parameters = params.query['query']

          expect(query_parameters.size).to eq 3
          expect(query_parameters['stat']).to eq 'passes_touchdown'
          expect(query_parameters['type']).to eq 'football_passing_stat'
          expect(query_parameters['place']).to eq 6
        end

        it 'fails validation if not football' do
          params = FootballTopStatsParams.new

          params.stat = 'passes_touchdown'
          params.type = 'hockey_offensive_stat'
          params.place = 5

          expect { params.query }.to raise_error ArgumentError
        end
      end
    end
  end
end
