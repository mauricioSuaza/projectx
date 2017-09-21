class RequestsController < ApplicationController

  before_action :set_request, only: [:show, :edit, :update, :destroy]

  def index
    @requets = Request.all
  end

  # GET /Donations/1
  # GET /Donations/1.json
  def show
  end

  # GET /Donations/new
  def new
    @request = Request.new
  end

  # GET /Donations/1/edit
  def edit
  end

  def request_donation
    if current_user.saldo > 0
      debugger
      @user = current_user.requests.create(requested: true,)
      respond_to do |format|
        if @user.update
          format.html { redirect_to @request, notice: 'Donacion requerida.' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render donation_path }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:notice] = 'Saldo insuficiente.'
      redirect_to donations_path
    end
  end
  
  # POST /Donations
  # POST /Donations.json
  def create
    @request = Request.new(request_params)
    #hacer que el valor pendiente del request sea el mismo valor de la solicitud al momento de su creacion
    @request.pending = @request.value
    respond_to do |format|
      if @request.save
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /Donations/1
  # PATCH/PUT /Donations/1.json
  def update
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to @request, notice: 'Request was successfully updated.' }
        format.json { render :show, status: :ok, location: @request }
      else
        format.html { render :edit }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /Donations/1
  # DELETE /Donations/1.json
  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to request_url, notice: 'Request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params.require(:request).permit(:value, :user_id, :balance)
    end
end
