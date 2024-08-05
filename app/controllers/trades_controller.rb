class TradesController < ApplicationController
  before_action :authenticate_user!

  def index
    @trades = Trade.all
  end

  def show
    @trade = Trade.find(params[:id])
  end

  def new
    @trade = current_user.trades.build
  end

  def create
    @trade = current_user.trades.build(trade_params)
    if @trade.save
      redirect_to trades_path, notice: 'Trade created successfully.'
    else
      render :new
    end
  end

  def destroy
    @trade = current_user.trades.find(params[:id])
    @trade.destroy
    redirect_to trades_path, notice: 'Trade deleted successfully.'
  end

  private

  def trade_params
    params.require(:trade).permit(:stock_name, :executed_at, :performance, :buy_or_sell, :quantity, :price, :description)
  end
end
