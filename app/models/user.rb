class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, length: { maximum: 255 }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :username, presence: true, length: {maximum: 64 }
  validates :password, presence: true, length: {minimum: 6, maximum: 128 }

  has_many :user_games
  has_many :games, through: :user_games

  def get_users_games(bgg_username, game_attribute)
    parsed_games = []
    loop do
      user_games_xml = get_games_xml(bgg_username)
      xml = parse_game_xml(user_games_xml, game_attribute)
      parsed_games = xml.map do |game|
        game.text
      end
      break if parsed_games.length > 0
    end
    # puts parsed_games
    return parsed_games
  end

  # Remove '&brief=1' to get more game info from API (image, year published, etc...)
  def get_games_xml(bgg_username)
    RestClient.get("https://www.boardgamegeek.com/xmlapi2/collection?username=#{bgg_username}&brief=1")
  end

  def parse_game_xml(xml, tag)
    @doc = Nokogiri::XML(xml)
    @doc.xpath("//#{tag}")
  end

end
