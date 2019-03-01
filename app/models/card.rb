class Card < ApplicationRecord

  def submit_new_card(name, list_id)

    trelloAPIToken = Trellozen::Application.credentials.trello_token
    trelloAPIKey = Trellozen::Application.credentials.trello_key
    RestClient::Request.execute(
      method: :post,
      url: "https://api.trello.com/1/cards?key=#{trelloAPIKey}&token=#{trelloAPIToken}&name=#{name}&idList=#{list_id}"
      )
  end

end
