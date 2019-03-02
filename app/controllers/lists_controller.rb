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
    card = List.new()
    card.submit_new_card(name,list_id)
  end

  def move_card
    card_id = params[:card][:card_id]
    list_id = params[:card][:list_id]
    move = List.move_card(card_id, list_id)
  end

  def get_updates
  end


  # GET /lists/1
  # GET /lists/1.json
  def show
  end

  # GET /lists/new
  def new
    @list = List.new
  end

  # GET /lists/1/edit
  def edit
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = List.new(list_params)

    respond_to do |format|
      if @list.save
        format.html { redirect_to @list, notice: 'List was successfully created.' }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1
  # PATCH/PUT /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to @list, notice: 'List was successfully updated.' }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    @list.destroy
    respond_to do |format|
      format.html { redirect_to lists_url, notice: 'List was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:name, :closed, :idnboard, :pos, :subscribed, :softlimit)
    end
end
