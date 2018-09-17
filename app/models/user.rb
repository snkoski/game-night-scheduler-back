class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, length: { maximum: 255 }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :username, presence: true, length: {maximum: 64 }
  validates :password, presence: true, length: {minimum: 6, maximum: 128 }

  has_many :user_games
  has_many :games, through: :user_games

  def games_hash(bgg_username)
    games_hash = {}
    loop do
      response = RestClient.get("https://www.boardgamegeek.com/xmlapi2/collection?username=#{bgg_username}&brief=1")
      @doc = Nokogiri::XML(response)
      items_xml = @doc.xpath("//item")
        items_xml.map do |game|
        games_hash[game.children.children.text] = game.attribute('objectid').value
      end
      break if games_hash.length > 0
    end
    # puts parsed_game_names
    return games_hash
  end

  def add_games(user_games_hash)
    new_games = {}
    new_games_hash = {}

    user_games_hash.each do |name, id|
      current_game = Game.all.find_by(name: name)
      if !current_game
        new_games[name] = id
      elsif !self.games.include?(current_game)
        self.games << current_game
      end
    end

    new_game_ids_array = new_games.values
    new_game_ids_string = new_game_ids_array.join(',')

    response = RestClient.get("https://www.boardgamegeek.com/xmlapi2/thing?id=" + new_game_ids_string)
    @doc = Nokogiri::XML(response)
    item = @doc.xpath("//item")
    min = @doc.xpath("//minplayers")
    max = @doc.xpath("//maxplayers")

    new_game_ids_array.each_index do |i|
      new_games_hash[new_game_ids_array[i]] = {
        name: item[i].children[5].attribute('value').text,
        min: min[i].attribute('value').value.to_i,
        max: max[i].attribute('value').value.to_i
      }
    end

    new_games_hash.each_value do |game|
      new_game = Game.create(name: game[:name], min_players: game[:min], max_players: game[:max])
      self.games << new_game
    end
  end

  # # Remove '&brief=1' to get more game info from API (image, year published, etc...)
  # def self.get_games_xml(bgg_username)
  #   RestClient.get("https://www.boardgamegeek.com/xmlapi2/collection?username=#{bgg_username}&brief=1")
  # end

  # def parse_game_xml(xml, tag)
  #   @doc = Nokogiri::XML(xml)
  #   @doc.xpath("//#{tag}")
  # end

  # Skip validations so you can change username for testing
  def change_username(new_username)
    self.username = new_username
    self.save(validate: false)
  end

end
