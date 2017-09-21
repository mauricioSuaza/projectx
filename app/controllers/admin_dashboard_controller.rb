class AdminDashboardController < ApplicationController

    before_action :authenticate_user!

    def dashboard_home
        render layout: "admin_dashboard_layout"
    end

    def users_admin
        @users = User.all
        render layout: "admin_dashboard_layout"
    end

    def donations_admin
        @donations = Donation.all
        render layout: "admin_dashboard_layout"
    end

    def requests_admin
        @requests = Request.all
        render layout: "admin_dashboard_layout"
    end

    def transactions_admin
        @transactions = Transaction.all
        render layout: "admin_dashboard_layout"
    end
end
