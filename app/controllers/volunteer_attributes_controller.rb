class VolunteerAttributesController < ApplicationController
  before_action :set_volunteer_attribute, only: [:show, :edit, :update, :destroy]

  # GET /volunteer_attributes
  # GET /volunteer_attributes.json
  def index
    @volunteer_attributes = VolunteerAttribute.all
  end

  # GET /volunteer_attributes/1
  # GET /volunteer_attributes/1.json
  def show
  end

  # GET /volunteer_attributes/new
  def new
    @volunteer_attribute = VolunteerAttribute.new
  end

  # GET /volunteer_attributes/1/edit
  def edit
  end

  # POST /volunteer_attributes
  # POST /volunteer_attributes.json
  def create
    @volunteer_attribute = VolunteerAttribute.new(volunteer_attribute_params)

    respond_to do |format|
      if @volunteer_attribute.save
        format.html { redirect_to @volunteer_attribute, notice: 'Volunteer attribute was successfully created.' }
        format.json { render :show, status: :created, location: @volunteer_attribute }
      else
        format.html { render :new }
        format.json { render json: @volunteer_attribute.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /volunteer_attributes/1
  # PATCH/PUT /volunteer_attributes/1.json
  def update
    respond_to do |format|
      if @volunteer_attribute.update(volunteer_attribute_params)
        format.html { redirect_to @volunteer_attribute, notice: 'Volunteer attribute was successfully updated.' }
        format.json { render :show, status: :ok, location: @volunteer_attribute }
      else
        format.html { render :edit }
        format.json { render json: @volunteer_attribute.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /volunteer_attributes/1
  # DELETE /volunteer_attributes/1.json
  def destroy
    @volunteer_attribute.destroy
    respond_to do |format|
      format.html { redirect_to volunteer_attributes_url, notice: 'Volunteer attribute was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_volunteer_attribute
      @volunteer_attribute = VolunteerAttribute.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def volunteer_attribute_params
      params.require(:volunteer_attribute).permit(:volunteer, :organization, :mentor)
    end
end
