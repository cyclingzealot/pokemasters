class VolunteerTaggingsController < ApplicationController
  before_action :set_volunteer_tagging, only: [:show, :edit, :update, :destroy]

  # GET /volunteer_taggings
  # GET /volunteer_taggings.json
  def index
    @volunteer_taggings = VolunteerTagging.all
  end

  # GET /volunteer_taggings/1
  # GET /volunteer_taggings/1.json
  def show
  end

  # GET /volunteer_taggings/new
  def new
    @volunteer_tagging = VolunteerTagging.new
  end

  # GET /volunteer_taggings/1/edit
  def edit
  end

  # POST /volunteer_taggings
  # POST /volunteer_taggings.json
  def create
    @volunteer_tagging = VolunteerTagging.new(volunteer_tagging_params)

    respond_to do |format|
      if @volunteer_tagging.save
        format.html { redirect_to @volunteer_tagging, notice: 'Volunteer tagging was successfully created.' }
        format.json { render :show, status: :created, location: @volunteer_tagging }
      else
        format.html { render :new }
        format.json { render json: @volunteer_tagging.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /volunteer_taggings/1
  # PATCH/PUT /volunteer_taggings/1.json
  def update
    respond_to do |format|
      if @volunteer_tagging.update(volunteer_tagging_params)
        format.html { redirect_to @volunteer_tagging, notice: 'Volunteer tagging was successfully updated.' }
        format.json { render :show, status: :ok, location: @volunteer_tagging }
      else
        format.html { render :edit }
        format.json { render json: @volunteer_tagging.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /volunteer_taggings/1
  # DELETE /volunteer_taggings/1.json
  def destroy
    @volunteer_tagging.destroy
    respond_to do |format|
      format.html { redirect_to volunteer_taggings_url, notice: 'Volunteer tagging was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_volunteer_tagging
      @volunteer_tagging = VolunteerTagging.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def volunteer_tagging_params
      params.require(:volunteer_tagging).permit(:volunteer_id, :volunteer_tag_id, :organization_id)
    end
end
