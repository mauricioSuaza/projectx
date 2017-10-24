class AdminDashboardController < ApplicationController

    before_action :authenticate_user!
    before_action :is_admin

    def is_admin
        unless current_user.has_role? :admin 
            redirect_to '/'
            flash[:notice] = "No tienes permiso para acceder a esta sección."
        end
    end

    def dashboard_home
        render layout: "admin_dashboard_layout"
    end

    def users_admin
        @users = User.paginate(:page => params[:page], :per_page => 80)
        render layout: "admin_dashboard_layout"
    end

    def donations_admin
        @donations = Donation.paginate(:page => params[:page], :per_page => 80)
        render layout: "admin_dashboard_layout"
    end

    def owner_transactions
        
        @owner_transactions = Transaction.where(request_id: nil).paginate(:page => params[:page], :per_page => 80) 
        @owner_transactions = @owner_transactions.order("created_at DESC")
        @transactions_total = 0
        @completed_total = 0
        @owner_transactions.each do |transaction|
            @transactions_total += transaction.value
            if transaction.status
                @completed_total += transaction.value
            end
        end
        
      render layout: "admin_dashboard_layout"
    end

    def blocked_users
      @blocked = User.where(blocked: true)
      render layout: "admin_dashboard_layout"
    end

    def unblock_user
      @user = User.find(params[:id])
      @user.update(blocked: false)
      redirect_to blocked_users_url
      flash[:notice] = "Usuario fue desbloqueado exitosamente"
    end

    def requests_admin
        @requests = Request.paginate(:page => params[:page], :per_page => 80)
        render layout: "admin_dashboard_layout"
    end

    def transactions_admin
        @transactions = Transaction.where("request_id IS NOT ?", nil).paginate(:page => params[:page], :per_page => 80)
        render layout: "admin_dashboard_layout"
    end
end
