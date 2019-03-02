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
    
    register_board_webhook(trelloAPIToken, trelloAPIKey, board_id[0])
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


  def self.register_board_webhook(api_token, api_key, boards)

    begin
       RestClient::Request.execute(
        :method => :post,
        :url => "https://api.trello.com/1/tokens/#{api_token}/webhooks/?key=#{api_key}",
        :data => { key: "#{api_key}",
                callbackURL: "https://e2ba7cdb.ngrok.io/",
                idModel: "#{boards}",
                description: "My first webhook"  }.to_json,
        :headers => {:accept => :json}) 
    rescue RestClient::ExceptionWithResponse => e
     return true 
    end
    return true
  end
end
