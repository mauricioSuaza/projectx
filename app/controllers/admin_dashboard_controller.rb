class AdminDashboardController < ApplicationController

    before_action :authenticate_user!
    before_action :is_admin
    before_action :find_transaction, only: [:restore_receiver_balance, :set_transaction_as_pending,
                                            :cancel_transaction]

    layout "admin_dashboard_layout", only: [:dashboard_home, :users_admin, :donations_admin,
                                            :owner_transactions, :transactions_panel, :blocked_users,
                                            :requests_admin, :transactions_admin]
    def is_admin
      unless current_user.has_role? :admin 
        redirect_to '/'
        flash[:notice] = "No tienes permiso para acceder a esta sección."
      end
    end

    def dashboard_home
    end

    def users_admin
      @filterrific = initialize_filterrific(
        User,
        params[:filterrific],
        persistence_id: false
      ) or return

      @users = @filterrific.find.paginate(:page => params[:page], :per_page => 80)
      @users = @users.order("created_at DESC")
    end

    def donations_admin
      @filterrific = initialize_filterrific(
        Donation,
        params[:filterrific],
        persistence_id: false
      ) or return
     
      @donations = @filterrific.find.paginate(:page => params[:page], :per_page => 80)
      @donations = @donations.order("created_at DESC")
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
    end

    def restore_receiver_balance
      user = User.find(@transaction.receiver_id)
      if user.update(saldo: user.saldo + @transaction.value)
        redirect_to transactions_admin_path
        flash[:notice] = "Saldo retornado exitosamente"
      else
        flash[:notice] = "La transacción no se pudo realizar, por favor intente de nuevo."
      end
    end


    def set_transaction_as_pending
      @transaction.completed = 0
      @transaction.status = false
      if @transaction.save
        flash[:notice] = "Transacción convertida a pendiente."
      else
        flash[:notice] = "No se pudo completar la transacción, vuelva a intentar."
      end
      redirect_to transactions_admin_path
    end

    def cancel_transaction
      @transaction.completed = 1
      @transaction.status = false
      if @transaction.save
        flash[:notice] = "Transacción cancelada exitosamente."
      else
        flash[:notice] = "No se pudo completar la transacción, vuelva a intentar."
      end
      redirect_to transactions_admin_path
    end

    def blocked_users
      @blocked = User.where(blocked: true)
    end

    def unblock_user
      @user = User.find(params[:id])
      @user.update(blocked: false)
      redirect_to blocked_users_url
      flash[:notice] = "Usuario fue desbloqueado exitosamente"
    end

    def requests_admin

      @filterrific = initialize_filterrific(
        Request,
        params[:filterrific],
        persistence_id: false
      ) or return
      @requests = @filterrific.find.paginate(:page => params[:page], :per_page => 80)
      @requests = @requests.order("created_at DESC")

    end

    def transactions_admin
      
      @filterrific = initialize_filterrific(
        Transaction,
        params[:filterrific],
        persistence_id: false
      ) or return

      @transactions = @filterrific.find.where("request_id IS NOT ?", nil).paginate(:page => params[:page], :per_page => 80)      
      @transactions = @transactions.order("created_at DESC")
    end


    private
    def find_transaction
      @transaction = Transaction.find(params[:transaction_id])
    end
end
