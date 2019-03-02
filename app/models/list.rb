class List < ApplicationRecord
require 'ostruct'

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
    
    # register_board_webhook(trelloAPIToken, trelloAPIKey, board_id)
    # register_board_webhook(trelloAPIToken, trelloAPIKey, cards)
    # register_webhook(trelloAPIToken, trelloAPIKey, board_id)
    @data << boards
    @data << listings
    @data << cards
    @data

    
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
  #   board_id = boards[0]
  #   apiToken = api_token
  #   api_call = RestClient.post "https://api.trello.com/1/tokens/#{api_token}/webhooks?key=#{api_key}&token=#{api_token}", { "key": "#{api_key}","callbackURL": "http://4f4ba129.ngrok.io/","idModel": "#{board_id}","description": "My first webhook"  }, {content_type: :json, accept: :json}
  # end

  # def self.register_cards_webhook(api_token, api_key, cards)
   #   board_id = '5c762a3ca0a4245a634b08bc'
  #   api_token = '4d22e16cb530b809520d3ee38d72590c5a67c1e8aff43b279e7af9f29508b0e9'
  #   api_key = 'cd3c6a6e25d03dd94768c6f6eea13a47'

  #   cards.each do |c_id|
  #     RestClient.post "https://api.trello.com/1/webhooks/#{api_token}/callbackURL", { "key": "#{api_key}","callbackURL": "http://4f4ba129.ngrok.io/","idModel": "#{c_id}","description": "My first webhook"  }.to_json, {content_type: :json, accept: :json}
  #   end
  # end

end
