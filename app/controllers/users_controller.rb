class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :is_blocked, only: [:dashboard, :my_referrals, :account_balance, :news]
    

    def is_blocked
      if current_user.blocked?
        redirect_to chats_path
        flash[:notice] = "Su cuenta a sido bloqueada, contacte al equipo de soporte."
      end
    end

    def dashboard
      @donations = current_user.donations.order('created_at DESC')
      @requests = current_user.requests.order('created_at DESC')
      render layout: "dashboard_layout"
    end

    def donation_send
      if params[:value]
        if current_user.send_donation(donation_params[:value].to_i)
          redirect_to '/my_dashboard',  :notice => "Donation sucessfully sent" 
        else
          redirect_to '/my_dashboard', :notice => "Invalid donation value" 
        end
      else
        redirect_to '/my_dashboard', :notice => "No donation value specified" 
      end
    end

    def donation_request
      if params[:value]
        current_user.request_donation(donation_params[:value].to_i)
        redirect_to '/my_dashboard', :notice => "Request succesfully sent" 
      else
        redirect_to '/my_dashboard', :notice => "Invalid donation value" 
      end
    end

    def my_referrals
      @hijos_1 = current_user.descendants(:at_depth => 1)
			@hijos_2 = current_user.descendants(:at_depth => 2)
			@hijos_3 = current_user.descendants(:at_depth => 3)
			@hijos_4 = current_user.descendants(:at_depth => 4)
			@hijos_5 = current_user.descendants(:at_depth => 5)
      @hijos_6 = current_user.descendants(:at_depth => 6)

      @amount_level_1 = current_user.level_one_amount
      @amount_level_2 = current_user.level_two_amount
      @amount_level_3 = current_user.level_three_amount
      @amount_level_4 = current_user.level_four_amount
      @amount_level_5 = current_user.level_five_amount
      @amount_level_6 = current_user.level_six_amount
      render layout: "dashboard_layout"
    end

    def account_balance
      @donations = current_user.donations
      @requests = current_user.requests
      render layout: "dashboard_layout"
    end

    def news
      render layout: "dashboard_layout"
    end
private
    def donation_params
      params.permit(:value)
    end
end
