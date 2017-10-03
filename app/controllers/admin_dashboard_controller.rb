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

    def requests_admin
        @requests = Request.paginate(:page => params[:page], :per_page => 15)
        render layout: "admin_dashboard_layout"
    end

    def transactions_admin
        @transactions = Transaction.paginate(:page => params[:page], :per_page => 15)
        render layout: "admin_dashboard_layout"
    end
end
