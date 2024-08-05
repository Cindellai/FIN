class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @subscriptions = current_user.subscriptions
  end

  def create
    @subscription = current_user.subscriptions.build(subscription_params)
    respond_to do |format|
      if @subscription.save
        format.html { redirect_to subscriptions_path, notice: 'Subscribed successfully.' }
        format.js
      else
        format.html { redirect_to subscriptions_path, alert: 'Subscription failed.' }
        format.js
      end
    end
  end

  def destroy
    @subscription = current_user.subscriptions.find(params[:id])
    @subscription.destroy
    respond_to do |format|
      format.html { redirect_to subscriptions_path, notice: 'Unsubscribed successfully.' }
      format.js
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:trader_id, :tier, :price, :duration, :status)
  end
end
