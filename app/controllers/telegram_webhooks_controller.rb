class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  context_to_action!

  def futbol(*args)
#     puts message
     if args.any?
	#create a new game	
	if self.chat['type'] != 'group'
		respond_with :message, text: "tenes que estar en un grupo para crear un partido"
		return
	end	
	day_en = translate_day_name_back(args[0].downcase.sub(/^./, &:upcase))
	@game_time =  "#{day_en} #{args[1]}"
	puts @game_time

	@game = Game.new
	@game.max_players = 10
	@game.recurrent = true
	@game.group_id = self.chat['id']
	@game.owner_id = self.from['id']
  	@game.owner_name = "#{self.from['first_name']} #{self.from['last_name']}"	
	@game.next_game = Chronic.parse(@game_time)
	@game.due_date = @game.next_game - (60*24*2)  # two days default due date

	@game.save
	
	respond_with :message, text: "Create un nuevo partido el #{@game.game_day} a las #{@game.game_time}. Ya pueden anotarse!" 
	
     else 
       resp = String.new
       @games = Game.where(group_id: self.chat['id'])
       case @games.count 
       when 0
	 resp = "No tenes partidos en este grupo, para crear un partido /futbol {dia} {horario}"
       when 1
	 @game = @games.take
       	 resp = "El proximo partido es el #{@game.game_day} a las #{@game.game_time}. Tenes hasta el #{@game.due_date} para confirmar. Por ahora hay #{@game.players.count} anotados."
       else
	 resp = "Hay #{@games.count} partidos activos en este grupo: \r\n"
	 idx = 1
	 @games.each do |g|
	   resp = resp + "#{idx}. #{g.game_day} a las #{g.game_time} [#{g.owner_name}]\r\n"
	   idx = idx + 1
	 end
       end

       respond_with :message, text: resp 
     end
  end

  def eliminar(*partido)
    resp = String.new
    if partido.any?
	@games = Game.where(group_id: self.chat['id'])
	game_idx =  partido.join(' ').to_i - 1  # TODO: make this right ;)
	if @games[game_idx].nil? 
	  resp = "No exsiste ese numero de partido."
	else
	  @game = @games[game_idx]
	  if @game.owner_id.to_s.eql? self.from['id'].to_s # fucking mess
	    @game.delete
	    resp = "Partido borrado" 	
	  else
	    resp = "El unico que puede borrar este partido es #{@game.owner_name} "
	  end
	end
  	respond_with :message, text: resp	
    else
     resp = "Necesito un numero de partido para eliminar."
     respond_with :message, text: resp
    end


  end

  
  def juego(*person)
         resp = String.new
         @games = Game.where(group_id: self.chat['id'])
         @games = @games.take

 	if person.any?
	  @persona = person.join(' ')
          @player = Player.new
          @player.name = "#{@persona}"
          @player.external_id = nil 
          @player.game = @game
	  @player.added_by = "#{self.from['first_name']} #{self.from['last_name']}" 
          @player.save 

	  respond_with :message, text: "agregue a #{@persona} al partido"
	else	
	  if @game.has_player(self.from['id'])
	    respond_with :message, text: "ya estas en el partido"
	    return
	  else
	    @player = Player.new
	    @player.name = "#{self.from['first_name']} #{self.from['last_name']}"
	    @player.external_id = self.from['id']
	    @player.game = @game
  	    @player.save
	  end

	  respond_with :message, text: "te agregue al partido"
  	end
  end

  def bajo
    # TODO: injection ready ;)
    @player = Player.find_by_external_id(self.from['id'])
   
    if @player
	@player.delete
        respond_with :message, text: "te elimine de la lista"
    else
        respond_with :message, text: "no estas anotado a este partido"
    end
  end

  def lista
    @game = Game.first
    idx = 1
    resp = String.new
    resp = "Titulares proximo partido: \r\n"
    @game.players.each do |player|
      resp = resp + "#{idx}. #{player.name}\r\n"
      idx = idx + 1 
    end
    respond_with :message, text: resp 

  end
  
  def start(*)
    respond_with :message, text: t('.content')
  end

  def help(*)
    respond_with :message, text: t('.content')
  end


  # catch all
  def message(message)

  end


  def action_missing(action, *_args)
    if command?
      respond_with :message, text: t('telegram_webhooks.action_missing.command', command: action)
    else
      respond_with :message, text: t('telegram_webhooks.action_missing.feature', action: action)
    end
  end

  private

  def translate_day_name_back(dayname_es) 
    if I18n.t(:"date.day_names").include? dayname_es
     idx = I18n.t(:"date.day_names").index dayname_es 
     return I18n.t(:"date.day_names", locale: :en)[idx]
    end
    nil
  end 

end
