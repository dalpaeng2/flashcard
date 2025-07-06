class CardsController < ApplicationController
  def new
    @deck = Deck.find(params[:deck_id])
    @card = @deck.cards.new
  end

  def create
    @deck = Deck.find(params[:deck_id])
    @card = @deck.cards.new(card_params)

    if @card.save
      redirect_to deck_path(@deck), notice: "Card created successfully."
    else
      render :new
    end
  end

  def show
    @deck = Deck.find(params[:deck_id])
    @card = @deck.cards.find(params[:id])
  end

  def edit
    @deck = Deck.find(params[:deck_id])
    @card = @deck.cards.find(params[:id])
  end

  def update
    @deck = Deck.find(params[:deck_id])
    @card = @deck.cards.find(params[:id])
    if @card.update(card_params)
      redirect_to deck_path(@deck), notice: "Card updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @deck = Deck.find(params[:deck_id])
    @card = @deck.cards.find(params[:id])
    @card.destroy
    redirect_to deck_path(@deck), notice: "Card deleted successfully."
  end

  def schedule
    @card = Card.find(params[:id])
    minutes = params[:next_review_minutes].to_i
    @card.update(next_review_at: Time.current + minutes.minutes)

    render json: { status: "success" }
  end

  private

  def card_params
    params.require(:card).permit(:front, :back)
  end
end
