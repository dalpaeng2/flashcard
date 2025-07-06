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

  def quiz
    @deck = Deck.find(params[:id])

    # 리뷰가 필요한 카드 중 하나를 우선적으로 선택
    @current_card = @deck.cards.due_for_review.order("RANDOM()").first

    # 만약 리뷰할 카드가 없다면 모든 카드에서 하나 선택
    @current_card ||= @deck.cards.order("RANDOM()").first
  end

  private

  def deck_params
    params.require(:deck).permit(:name, :description)
  end
end
