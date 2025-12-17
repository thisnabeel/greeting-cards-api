class CustomizationsController < ApplicationController
  before_action :set_customization, only: [:show, :edit, :update, :destroy]

  # GET /customizations
  # GET /customizations.json
  def index
    @customizations = Customization.all
  end

  # GET /customizations/1
  # GET /customizations/1.json
  def show
  end

  # GET /customizations/new
  def new
    @customization = Customization.new
  end

  # GET /customizations/1/edit
  def edit
  end

  # POST /customizations
  # POST /customizations.json
  def create
    @customization = Customization.new(customization_params)

    respond_to do |format|
      if @customization.save
        format.html { redirect_to @customization, notice: 'Customization was successfully created.' }
        format.json { render :show, status: :created, location: @customization }
      else
        format.html { render :new }
        format.json { render json: @customization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customizations/1
  # PATCH/PUT /customizations/1.json
  def update
    respond_to do |format|
      if @customization.update(customization_params)
        format.html { redirect_to @customization, notice: 'Customization was successfully updated.' }
        format.json { render :show, status: :ok, location: @customization }
      else
        format.html { render :edit }
        format.json { render json: @customization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customizations/1
  # DELETE /customizations/1.json
  def destroy
    @customization.destroy
    respond_to do |format|
      format.html { redirect_to customizations_url, notice: 'Customization was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customization
      @customization = Customization.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customization_params
      params.require(:customization).permit(:title, :description, :choices, :cost, :position, :product_id, :active)
    end
end
