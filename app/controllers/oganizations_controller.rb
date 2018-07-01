class OganizationsController < ApplicationController
  before_action :set_oganization, only: [:show, :edit, :update, :destroy]

  # GET /oganizations
  # GET /oganizations.json
  def index
    @oganizations = Oganization.all
  end

  # GET /oganizations/1
  # GET /oganizations/1.json
  def show
  end

  # GET /oganizations/new
  def new
    @oganization = Oganization.new
  end

  # GET /oganizations/1/edit
  def edit
  end

  # POST /oganizations
  # POST /oganizations.json
  def create
    @oganization = Oganization.new(oganization_params)

    respond_to do |format|
      if @oganization.save
        format.html { redirect_to @oganization, notice: 'Oganization was successfully created.' }
        format.json { render :show, status: :created, location: @oganization }
      else
        format.html { render :new }
        format.json { render json: @oganization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /oganizations/1
  # PATCH/PUT /oganizations/1.json
  def update
    respond_to do |format|
      if @oganization.update(oganization_params)
        format.html { redirect_to @oganization, notice: 'Oganization was successfully updated.' }
        format.json { render :show, status: :ok, location: @oganization }
      else
        format.html { render :edit }
        format.json { render json: @oganization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /oganizations/1
  # DELETE /oganizations/1.json
  def destroy
    @oganization.destroy
    respond_to do |format|
      format.html { redirect_to oganizations_url, notice: 'Oganization was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_oganization
      @oganization = Oganization.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def oganization_params
      params.require(:oganization).permit(:name, :email, :web, :enabled)
    end
end
