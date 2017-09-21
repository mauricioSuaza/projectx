class DonationsController < ApplicationController

  before_action :set_donation, only: [:show, :edit, :update, :destroy]
 

  def index
    @donations = Donation.all
  end

  # GET /Donations/1
  # GET /Donations/1.json
  def show
  end

  # GET /Donations/new
  def new
    @donation = Donation.new
  end

  # GET /Donations/1/edit
  def edit
  end

  # POST  Send donations
  def sent_donation (value)
    
    @donation = Donation.new(value: 30)
    puts @donation
=begin
    if (current_user.saldo > 0)
      #randon users
        #donation_receptors = User.offset(rand(User.count)).limit(3)

      #testing with the last 3 users on db with records on saldo
        donation_receptors = User.last(3)

      #select the lowest request from the users
        lowest_donation_request = donation_receptors.sort_by(&:saldo).first.saldo
        porcent = lowest_donation_request*20/100

      #Donation amount
       donation = params[:donation][:value]

      while donation > 0
        if donation >= porcent
          donation_receptors.each{|k, v|
            #a[k] == LO QUE ESTA PIDIENDO
            if (donation >= porcent && a[k] >= donation_receptors[k] + porcent)
              donation_receptors[k] += porcent
              donation -= porcent   
            else
              estado[k] = true
            end
          }
        else
          porcent = donation/5.to_f
        end

        if (estado.values.all? {|x| x == true})
          residuo = saldo
          saldo = 0 
        end
      end
    else
      redirect_to donations_path
      flash[:notice] = 'saldo es insuficiente para realizar donación'
      redirect_to donations_root
    end
=end
  end

  # POST /Donations
  # POST /Donations.json
  def create
    @Donation = Donation.new(donation_params)
    respond_to do |format|
      if @donation.save
        format.html { redirect_to @Donation, notice: 'Donation was successfully created.' }
        format.json { render :show, status: :created, location: @Donation }
      else
        format.html { render :new }
        format.json { render json: @Donation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /Donations/1
  # PATCH/PUT /Donations/1.json
  def update
    respond_to do |format|
      if @donation.update(donation_params)
        format.html { redirect_to @Donation, notice: 'Donation was successfully updated.' }
        format.json { render :show, status: :ok, location: @Donation }
      else
        format.html { render :edit }
        format.json { render json: @Donation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /Donations/1
  # DELETE /Donations/1.json
  def destroy
    @donation.destroy
    respond_to do |format|
      format.html { redirect_to Donations_url, notice: 'Donation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_donation
      @donation = Donation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def donation_params
      params.require(:donation).permit(:value, :user_id, :balance)
    end
end
