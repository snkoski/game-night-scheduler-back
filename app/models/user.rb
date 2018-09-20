class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, length: { maximum: 255 }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :username, presence: true, length: {maximum: 64 }
  validates :password, presence: true, length: {minimum: 6, maximum: 128 }

  has_many :user_games
  has_many :games, through: :user_games
  has_many :user_groups
  has_many :groups, through: :user_groups

  # Skip validations so you can change username for testing
  def change_username(new_username)
    self.username = new_username
    self.save(validate: false)
  end

  def sync_games(bgg_username)
    games = games_hash(bgg_username)
    new_games = check_for_new_games(games)
    new_game_ids_array = new_games.keys
    new_game_ids_string = new_game_ids_array.join(',')
    response = get_games_xml(new_game_ids_string)
    # item = get_xml_tag(response, "item")
    # name = get_xml_tag(response, "name")
    id = get_xml_tag(response, "item")
    min = get_xml_tag(response, "minplayers")
    max = get_xml_tag(response, "maxplayers")
    thumbnail = get_xml_tag(response, "thumbnail")
    image = get_xml_tag(response, "image")
    play_time = get_xml_tag(response, "playingtime")
    description = get_xml_tag(response, "description")
    new_games_hash = get_new_games_hash(new_game_ids_array, new_games, id, min, max, thumbnail, image, play_time, description)
    # return new_games_hash
    create_and_add_new_games(new_games_hash)
  end

  # private
  def games_hash(bgg_username)
    games_hash = {}
    loop do
      response = RestClient.get("https://www.boardgamegeek.com/xmlapi2/collection?username=#{bgg_username}&brief=1&subtype=boardgame&own=1")
      @doc = Nokogiri::XML(response)
      items_xml = @doc.xpath("//item")
        items_xml.map do |game|
        games_hash[game.attribute('objectid').value] = { name: game.children.children.text, bgg_id: game.attribute('objectid').value }
      end
      break if games_hash.length > 0
    end
    return games_hash
  end

  def check_for_new_games(all_games_hash)
    new_games = {}
    all_games_hash.each_value do |v|
      current_game = Game.all.find_by(bgg_id: v[:bgg_id])
      if !current_game
        new_games[v[:bgg_id]] = {name: v[:name], bgg_id: v[:bgg_id]}
      elsif !self.games.find_by(bgg_id: v[:bgg_id])
        self.games << current_game
        # puts v[:name]
      end
    end
    return new_games
  end


  # def games_hash(bgg_username)
  #   games_hash = {}
  #   loop do
  #     response = RestClient.get("https://www.boardgamegeek.com/xmlapi2/collection?username=#{bgg_username}&brief=1&subtype=boardgame&own=1")
  #     @doc = Nokogiri::XML(response)
  #     items_xml = @doc.xpath("//item")
  #       items_xml.map do |game|
  #       games_hash[game.children.children.text] = game.attribute('objectid').value
  #     end
  #     break if games_hash.length > 0
  #   end
  #   return games_hash
  # end

  # def check_for_new_games(all_games_hash)
  #   new_games = {}
  #   all_games_hash.each do |name, id|
  #     current_game = Game.all.find_by(name: name)
  #     if !current_game
  #       new_games[name] = id
  #     elsif !self.games.find_by(name: name)
  #       self.games << current_game
  #     end
  #   end
  #   return new_games
  # end

  def get_games_xml(game_ids_string)
    return RestClient.get("https://www.boardgamegeek.com/xmlapi2/thing?id=" + game_ids_string)
  end

  def get_xml_tag(response, tag_name)
    @doc = Nokogiri::XML(response)
    return @doc.xpath("//#{tag_name}")
  end

  def get_new_games_hash(games_array, new_games, id, min, max, thumbnail, image, play_time, description)
    new_games_hash = {}
    games_array.each_index do |i|
      # puts new_games[id[i].attribute('id').value][:name]
      if !thumbnail[i] || !image
        next
      end
      new_games_hash[games_array[i]] = {

        name: new_games[id[i].attribute('id').value][:name],
        bgg_id: id[i].attribute('id').value,
        min: min[i].attribute('value').value.to_i,
        max: max[i].attribute('value').value.to_i,
        thumbnail: thumbnail[i].children.text,
        image: image[i].children.text,
        play_time: play_time[i].attribute('value').value.to_i,
        description: description[i].children.text
      }
    end
    return new_games_hash
  end

  def create_and_add_new_games(new_games_hash)
    new_games_hash.each_value do |game|
        new_game = Game.create(name: game[:name], bgg_id: game[:bgg_id], min_players: game[:min], max_players: game[:max], thumbnail: game[:thumbnail], image: game[:image], play_time: game[:play_time], description: game[:description])
        self.games << new_game
      end
  end
end
