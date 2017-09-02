class Game < ApplicationRecord
  has_many :players

  def has_player(player_external_id)
	player_external_id = player_external_id.to_s
	self.players.each do | player | 
		if player.external_id == player_external_id
			return true
		end
	end	
	
	return false
  end

  def game_day()
	I18n.l(self.next_game, format: '%A')
  end

  def game_time()
       self.next_game.strftime("%H")
  end

end
