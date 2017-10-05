class AdminDashboardController < ApplicationController

    before_action :authenticate_user!
    

    def dashboard_home
        render layout: "admin_dashboard_layout"
    end

    def users_admin
        @users = User.paginate(:page => params[:page], :per_page => 15)
        render layout: "admin_dashboard_layout"
    end

    def donations_admin
        @donations = Donation.paginate(:page => params[:page], :per_page => 15)
        render layout: "admin_dashboard_layout"
    end

    def owner_transactions
        if current_user.has_role? :owner 
            @owner_transactions = Transaction.where(request_id: nil).paginate(:page => params[:page], :per_page => 10) 
        end
        render layout: "admin_dashboard_layout"
    end

    def requests_admin
        @requests = Request.paginate(:page => params[:page], :per_page => 15)
        render layout: "admin_dashboard_layout"
    end

    def transactions_admin
        @transactions = Transaction.where("request_id not ?", nil).paginate(:page => params[:page], :per_page => 15)
        render layout: "admin_dashboard_layout"
    end
end
