class TransactionsController < ApplicationController


  def add_invoice
    @transaction = Transaction.find(params[:transaction_id])
    @transaction.invoice = params[:invoice]
    @transaction.save!
    redirect_to '/my_dashboard', notice: "image succesfully saved"
  end

  def confirm_transaction
    @transaction = Transaction.find(params[:transaction_id])
    if @transaction.receiver_id == current_user.id
        @transaction.update(status: true)
        donation_check @transaction
        if @transaction.request_id
          request_check @transaction
        end
        create_notification @transaction

        if current_user.has_role?(:owner)
          redirect_to '/my_transactions', notice: "Transaction succesfully cofirmed"
        else
          redirect_to '/my_dashboard', notice: "Transaction succesfully cofirmed"
        end
        
    else
        redirect_to '/my_dashboard', notice: "you don't have permission to acces this transaction"
    end

  end

  def donation_check (transaction)
    @donation = Donation.find(transaction.donation_id)
    if (@donation.transactions.all? {|transc| transc.status == true}) && (@donation.pending==0)
      @donation.update(completed: true)
      UserWorker.perform_in(40.seconds,  @donation.id)
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
