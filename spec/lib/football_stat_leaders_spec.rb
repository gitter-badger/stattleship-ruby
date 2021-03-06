require 'spec_helper'

module Stattleship
  RSpec.describe FootballStatLeaders do
    describe '#leaders' do
      it 'returns all the nfl_leaders' do
        expect(nfl_leaders.count).to eq 4
      end
    end

    describe '.fetch' do
      it 'makes a request to fetch football stat leaders' do
        stub_request(:get, /#{base_api_url}.*/).
          to_return(body: File.read('spec/fixtures/nfl/stat_leaders.json'))

        FootballStatLeaders.fetch(params: params)

        expect(
          a_request(:get,
                    "#{base_api_url}/football/nfl/stat_leaders?place=5&stat=rushes_yards&type=football_rushing_stat")
        ).to have_been_made.once
      end

      it 'parses and builds the football game logs' do
        stub_request(:get, /#{base_api_url}.*/).
          to_return(body: File.read('spec/fixtures/nfl/stat_leaders.json'))

        stat_leaders = FootballStatLeaders.fetch(params: params)

        expect(stat_leaders.count).to eq 4

        stat_leaders.each do |stat_leader|
          expect(stat_leader).to be_a Leader
        end
      end

      def params
        Stattleship::Params::FootballStatLeadersParams.new.tap do |params|
          params.stat = 'rushes_yards'
          params.type = 'football_rushing_stat'
          params.place = 5
        end
      end
    end
  end

  RSpec.describe Leader do
    it 'knows its place' do
      expect(nfl_leaders.first.place).to eq 1
      expect(nfl_leaders.last.place).to eq 4
    end

    it 'knows about a player in first place' do
      leader = nfl_leaders.first

      expect(leader.player).to be_a Stattleship::Models::Player
      expect(leader.player.name).to eq('Adrian Peterson')
      expect(leader.player.first_name).to eq('Adrian')
      expect(leader.player.last_name).to eq('Peterson')
    end

    it 'knows about a player in second player in list' do
      leader = nfl_leaders[1]

      expect(leader.player).to be_a Stattleship::Models::Player
      expect(leader.player.name).to eq('Doug Martin')
      expect(leader.player.first_name).to eq('Doug')
      expect(leader.player.last_name).to eq('Martin')
    end

    it 'knows about a player position' do
      leader = nfl_leaders.first
      player = leader.player

      expect(player.position_abbreviation).to eq('RB')
      expect(player.position_name).to eq('Runningback')
    end

    it 'knows about the player team' do
      leader = nfl_leaders[1]
      team = leader.team

      expect(team).to be_a Stattleship::Models::Team
      expect(team.full_name).to eq('Tampa Bay Buccaneers')
      expect(team.name).to eq('Tampa Bay')
      expect(team.nickname).to eq('Buccaneers')
      expect(team.location).to eq('Tampa Bay')
    end

    it 'can format a readable sentence' do
      leader = nfl_leaders.first

      expect(
        leader.to_sentence
      ).to eq 'Adrian Peterson is in first place with 1418 rushes_yards'
    end
  end
end
