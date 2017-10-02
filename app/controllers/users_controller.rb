class UsersController < ApplicationController
    before_action :authenticate_user!

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
      @current_user_children = current_user.children
      render layout: "dashboard_layout"
      @hijos_1 = @user.descendants(:at_depth => 1)
			@hijos_2 = @user.descendants(:at_depth => 2)
			@hijos_3 = @user.descendants(:at_depth => 3)
			@hijos_4 = @user.descendants(:at_depth => 4)
			@hijos_5 = @user.descendants(:at_depth => 5)
			@hijos_6 = @user.descendants(:at_depth => 6)
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
