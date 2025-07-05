class DecksController < ApplicationController
  def index
    @decks = Deck.all
  end

  def new
    @deck = Deck.new
  end

  def create
    @deck = Deck.new(deck_params)
    if @deck.save
      redirect_to decks_path, notice: "Deck was successfully created."
    else
      render :new
    end
  end

  def show
    @deck = Deck.find(params[:id])
  end

  def edit
    @deck = Deck.find(params[:id])
  end

  def update
    @deck = Deck.find(params[:id])
    if @deck.update(deck_params)
      redirect_to decks_path, notice: "Deck was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @deck = Deck.find(params[:id])
    @deck.destroy
    redirect_to decks_path, notice: "Deck was successfully deleted."
  end

  private

  def deck_params
    params.require(:deck).permit(:name, :description)
  end
end
