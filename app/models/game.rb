class Game < ApplicationRecord
  # validates :name, uniqueness: true

  has_many :user_games
  has_many :users, through: :user_games

  # def get_number_of_players(game_id)
  #   response = RestClient.get("https://www.boardgamegeek.com/xmlapi2/thing?id=#{game_id}")
  #   @doc = Nokogiri::XML(response)
  # end
  #
  # def self.add_game(game_name)
  #   @game = Game.find_by(name: game_name)
  #   if @game == nil
  #     Game.create(name: game_name)
  #   end
  # end

  # def get_min_players(game_id)
  #   response = RestClient.get("https://www.boardgamegeek.com/xmlapi2/thing?id=#{game_id}")
  #   @doc = Nokogiri::XML(response)
  #   min_players_xml = @doc.xpath("//minplayers")
  #   self.min_players = min_players_xml.attribute('value').value.to_i
  #   self.save
  # end
  #
  # def get_max_players(game_id)
  #   response = RestClient.get("https://www.boardgamegeek.com/xmlapi2/thing?id=#{game_id}")
  #   @doc = Nokogiri::XML(response)
  #   max_players_xml = @doc.xpath("//maxplayers")
  #   self.max_players = max_players_xml.attribute('value').value.to_i
  #   self.save
  # end

end
