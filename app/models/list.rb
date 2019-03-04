class List < ApplicationRecord
require 'ostruct'
include HTTParty

  def self.get_all_trello_data

    trelloAPIToken = Trellozen::Application.credentials.trello_token
    trelloAPIKey = Trellozen::Application.credentials.trello_key
    @data = []

    response = JSON.parse(RestClient::Request.execute(
        method: :get,
        url: "https://api.trello.com/1/members/jeanmalan5/?key=#{trelloAPIKey}&token=#{trelloAPIToken}"
      ), object_class: OpenStruct)

    board_id = response.idBoards

    boards = JSON.parse(RestClient::Request.execute(
      method: :get,
      url: "https://api.trello.com/1/boards/#{board_id[0]}?fields=name,url&key=#{trelloAPIKey}&token=#{trelloAPIToken}",
      ), object_class: OpenStruct )

    listings = JSON.parse(RestClient::Request.execute(
        method: :get,
        url: "https://api.trello.com/1/boards/#{board_id[0]}/lists/?&key=#{trelloAPIKey}&token=#{trelloAPIToken}",
        ), object_class: OpenStruct)

    cards = JSON.parse(RestClient::Request.execute(
      method: :get,
      url: "https://api.trello.com/1/boards/#{board_id[0]}/cards/?&key=#{trelloAPIKey}&token=#{trelloAPIToken}"
    ), object_class: OpenStruct)
    
    register_card_webhooks(trelloAPIToken, trelloAPIKey, cards)
    @data << boards << listings << cards
  end




  def submit_new_card(name, list_id)
    trelloAPIToken = Trellozen::Application.credentials.trello_token
    trelloAPIKey = Trellozen::Application.credentials.trello_key
    RestClient::Request.execute(
      method: :post,
      url: "https://api.trello.com/1/cards?key=#{trelloAPIKey}&token=#{trelloAPIToken}&name=#{name}&idList=#{list_id}"
      )
  end

  def self.move_card(card_id, list_id)
    trelloAPIToken = Trellozen::Application.credentials.trello_token
    trelloAPIKey = Trellozen::Application.credentials.trello_key
    RestClient::Request.execute(
      method: :put,
      url: "https://api.trello.com/1/cards/#{card_id}?idList=#{list_id}&key=#{trelloAPIKey}&token=#{trelloAPIToken}"
    )

  end


  # def self.register_board_webhook(api_token, api_key, boards)
  #   address = Trellozen::Application.credentials.ngrok_address
    
  #   HTTParty.post("https://api.trello.com/1/tokens/#{api_token}/webhooks/",
  #                 :body => {  :key => "#{api_key}", 
  #                             :callbackURL => "#{address}/handle_webhook", 
  #                             :idModel => "#{boards}", 
  #                             :description => 'This is the description for the problem'}.to_json, 
  #                 :headers => { 'Content-Type' => 'application/json' } )

  # end

  # def self.delete_board_webhook(api_token, api_key, boards)

  #   HTTParty.delete("https://api.trello.com/1/tokens/#{api_token}/webhooks/",
  #                 :body => {  :key => "#{api_key}", 
  #                             :callbackURL => "#{address}/handle_webhook", 
  #                             :idModel => "#{boards}", 
  #                             :description => 'This is the description for the problem'}.to_json, 
  #                 :headers => { 'Content-Type' => 'application/json' } )
  # end

  def self.register_card_webhooks(api_token, api_key, cards)
    address = Trellozen::Application.credentials.ngrok_address
    
    cards.each do |c|
    HTTParty.post("https://api.trello.com/1/tokens/#{api_token}/webhooks/",
                  :body => {  :key => "#{api_key}", 
                              :callbackURL => "#{address}/handle_webhook", 
                              :idModel => "#{c.id}", 
                              :description => 'This is the description for the problem'}.to_json, 
                  :headers => { 'Content-Type' => 'application/json' } )
    end

  end

  def self.get_card_activity(card_id)
    trelloAPIToken = Trellozen::Application.credentials.trello_token
    trelloAPIKey = Trellozen::Application.credentials.trello_key

    # get the acticity id from the webhoob
    actions = JSON.parse(RestClient::Request.execute(
        method: :get,
        url: "https://api.trello.com/1/card/#{card_id}/actions?limit=1&filter=all&key=#{trelloAPIKey}&token=#{trelloAPIToken}",
        ), object_class: OpenStruct)
     card = actions[0][:id]

    # Send a get request to query the activity
    activity = JSON.parse(RestClient::Request.execute(
      method: :get,
      url: "https://api.trello.com/1/actions/#{card}/display?&key=#{trelloAPIKey}&token=#{trelloAPIToken}",
      ), object_class: OpenStruct)  
      

    if activity.translationKey == "action_move_card_from_list_to_list"
      return ("Moved card from: " + activity.entities.listBefore.text  + ", to:  " + activity.entities.listAfter.text)
    else 
      return "Card was not moved"
    end

  end


end

# curl ""
# curl  "https://api.trello.com/1/actions/5c7cf591871e1684a105e91f/display?filter=all&key=cd3c6a6e25d03dd94768c6f6eea13a47&token=4d22e16cb530b809520d3ee38d72590c5a67c1e8aff43b279e7af9f29508b0e9"

# 5c7cf591871e1684a105e91f
# trello_secret=f2396a3788ebadc88855e8d22a28a6e42db09b67defcbf5e50effef4c619d400
# trello_token=4d22e16cb530b809520d3ee38d72590c5a67c1e8aff43b279e7af9f29508b0e9
# trello_key= cd3c6a6e25d03dd94768c6f6eea13a47