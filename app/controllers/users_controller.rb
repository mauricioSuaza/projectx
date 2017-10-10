class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :is_blocked, only: [:dashboard, :my_referrals, :account_balance, :news, :notifications]
    before_action :is_user, only: [:dashboard, :my_referrals, :account_balance, :news, :notifications]
    before_action :is_admin, only: [:show]

    def is_admin
      unless current_user.has_role? :admin 
          redirect_to '/'
          flash[:notice] = "No tienes permiso para acceder a esta sección."
      end
    end

    def is_user
      unless current_user.has_role? :user 
          redirect_to '/'
          flash[:notice] = "No tienes permiso para acceder a esta sección."
      end
    end

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
      if params[:value].to_f > 0
        if current_user.saldo > params[:value].to_f
          current_user.request_donation(donation_params[:value].to_i)
          redirect_to '/my_dashboard', :notice => "Request succesfully sent" 
        else
          redirect_to '/my_dashboard', :notice => "Saldo insuficiente" 
        end
      else
        redirect_to '/my_dashboard', :notice => "No donation value specified" 
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
        @news = Article.all
        render layout: "dashboard_layout"
    end

    def show
        @user = User.find(params[:id])
        @donations = @user.donations
        @requests = @user.requests
        @completed_requests_number = @user.requests.where(completed: true).count
        @donations_number =  @user.donations.count 
        @completed_donations_number = @user.donations.where(completed: true).count
        @requests_number = @user.requests.count       
        @donations_total =  total_donations_value @user
        @requests_total =  total_requests_value @user
        render layout: "admin_dashboard_layout"
    end

    def total_donations_value (user)
        total = 0
        user.donations.each do |don|
            total += don.value
        end
        total
    end

    def total_requests_value (user)
        total = 0
        user.requests.each do |req|
            total += req.value
        end
        total
    end
    
    def notifications
      @notifications = current_user.notifications.order('created_at DESC')
      current_user.notifications.order('created_at DESC').where(read: false).update(read: true)
      render layout: "dashboard_layout"
    end

private
    def donation_params
      params.permit(:value)
    end
end
