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

    # 리뷰가 필요한 카드들을 우선적으로 선택
    @cards = @deck.cards.due_for_review.order("RANDOM()").limit(10)

    # 만약 리뷰할 카드가 부족하다면 모든 카드에서 추가로 선택
    if @cards.count < 10
      additional_cards = @deck.cards.where.not(id: @cards.pluck(:id))
                                   .order("RANDOM()")
                                   .limit(10 - @cards.count)
      @cards = (@cards + additional_cards).shuffle
    end

    @current_card_index = 0
    @current_card = @cards.first
  end

  private

  def deck_params
    params.require(:deck).permit(:name, :description)
  end
end
