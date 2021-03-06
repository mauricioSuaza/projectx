class TransactionsController < ApplicationController

  def add_invoice
    @transaction = Transaction.find(params[:transaction_id])
    @transaction.invoice = params[:invoice]
    @transaction.save!
    transaction_receiver = User.find(@transaction.receiver_id).has_role? :user
    TransactionMailer.transaction_invoice(@transaction).deliver_later if transaction_receiver == true
    redirect_to '/my_dashboard', notice: "Imagen enviada exitosamente"
  end

  def confirm_transaction
    @transaction = Transaction.find(params[:transaction_id])
    @receiver = User.find(@transaction.receiver_id)
    if (@transaction.receiver_id == current_user.id) || (current_user.has_role? :admin)
        @transaction.update(status: true)
        donation_check @transaction
        if @transaction.request_id
          request_check @transaction
        end
        create_notification @transaction
        TransactionMailer.transaction_confirm(@transaction).deliver_later
        if current_user.has_role?(:admin)
          redirect_to :back, notice: "Transacción confirmada exitósamente"
        else
          redirect_to '/my_dashboard', notice: "Transacción confirmada exitósamente"
        end  
    else
        redirect_to '/my_dashboard', notice: "No tienes permiso para acceder a esta transacción"
    end
  end

  def donation_check (transaction)
    @donation = Donation.find(transaction.donation_id)
    if (@donation.transactions.all? {|transc| transc.status == true}) && (@donation.pending==0)
      @donation.update_attribute('completed', true)
      @donation.update(confirmed_at: DateTime.now)
      UserWorker.perform_in(15.days - (@donation.days_passed_since_created).days,  @donation.id)
    end
    @donation
  end

  def request_check (transaction)
    @request = Request.find(transaction.request_id)
    if @request.transactions.all? {|transc| transc.status == true}
      @request.update(completed: true)
    end
  end

  def show
    @transaction = Transaction.find(params[:id])
    render layout: "admin_dashboard_layout"
  end


  def create_notification(data)
    @sender = User.find(@transaction.sender_id)
    @receiver = User.find(@transaction.receiver_id)
    if !data.nil?
      @sender.notifications.create(owner_id: data.sender_id, transaction_value: data.value, read: false)
    end
  end

private
  def invoice_params
    params.permit(:invoice)
  end
end
