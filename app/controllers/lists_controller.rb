class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy]
  protect_from_forgery with: :null_session
  

  # GET /lists
  # GET /lists.json
  def index
    data = List.get_all_trello_data
    @boards = data[0]
    @lists = data[1]
    @cards = data[2]
  end

  def post_new_card
    name = params[:card][:idnboard]
    list_id = params[:card][:id]
    card = List.new
    card.submit_new_card(name,list_id)
  end

  def move_card
    card_id = params[:card][:card_id]
    list_id = params[:card][:list_id]
    move = List.move_card(card_id, list_id)
  end


end
