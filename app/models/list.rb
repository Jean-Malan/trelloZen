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
    
    # register_webhook(trelloAPIToken, trelloAPIKey, board_id)
    @data << boards
    @data << listings
    @data << cards
    @data

    
  end

  # def self.register_webhook(api_token, api_key, boards)
  #   binding.pry
  #   boards.each do |b_id|
  #     RestClient.post "https://api.trello.com/1/tokens/#{api_token}/webhooks", { "key": "#{api_key}","callbackURL": "http://4f4ba129.ngrok.io/","idModel": "#{b_id}","description": "My first webhook"  }.to_json, {content_type: :json, accept: :json}
  #   end
  # end

end
