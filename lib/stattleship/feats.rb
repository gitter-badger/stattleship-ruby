module Stattleship
  class Feat < OpenStruct
    def name
      subject.name
    end

    def subject
      player || team
    end

    def to_sentence
      sentence_vs_on
    end
  end

  class Feats < Stattleship::Endpoint
    def populate
      feats.each do |feat|
        populate_games(feat)

        games.each do |game|
          populate_game(game)
        end

        populate_teams(feat)

        populate_players(feat)
        populate_player(feat.player)
      end
    end
  end

  module FeatsRepresenter
    include Roar::JSON
    include Roar::Coercion
    include Stattleship::Models

    collection :feats, class: Stattleship::Feat do
      property :accomplished_vs
      property :accomplishment
      property :actual, type: BigDecimal
      property :category
      property :game_id
      property :game_slug
      property :humanized_stat_type
      property :level, type: Integer
      property :name
      property :on
      property :opponent_abbrev
      property :opponent_location
      property :opponent_name
      property :opponent_nickname
      property :opponent_slug
      property :player_id
      property :player_slug
      property :sentence
      property :sentence_on
      property :sentence_vs
      property :sentence_vs_on
      property :subject_id
      property :subject_name
      property :subject_team_name
      property :subject_team_abbrev
      property :subject_team_location
      property :subject_team_nickname
      property :subject_team_slug
      property :subject_type
      property :subject_slug
      property :team_id
      property :team_slug
      property :verb
      property :vs
      property :league_id
      property :season_id
    end

    collection :away_teams, extend: TeamRepresenter,
                            class: Team

    collection :home_teams, extend: TeamRepresenter,
                            class: Team

    collection :winning_teams, extend: TeamRepresenter,
                               class: Team

    collection :games, extend: GameRepresenter,
                       class: Game

    collection :leagues, extend: LeagueRepresenter,
                         class: League

    collection :seasons, extend: SeasonRepresenter,
                         class: Season

    collection :venues, extend: VenueRepresenter,
                        class: Venue

    collection :players, extend: PlayerRepresenter,
                         class: Player

    collection :teams, extend: TeamRepresenter,
                       class: Team
  end
end
