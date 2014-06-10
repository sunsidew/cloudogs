class DocsHistoriesController < ApplicationController
  before_action :set_docs_history, only: [:show, :edit, :update, :destroy]

  # GET /docs_histories
  # GET /docs_histories.json
  def index
    @docs_histories = DocsHistory.all
  end

  # GET /docs_histories/1
  # GET /docs_histories/1.json
  def show
  end

  # GET /docs_histories/new
  def new
    @docs_history = DocsHistory.new
  end

  # GET /docs_histories/1/edit
  def edit
  end

  # POST /docs_histories
  # POST /docs_histories.json
  def create
    @docs_history = DocsHistory.new(docs_history_params)

    respond_to do |format|
      if @docs_history.save
        format.html { redirect_to @docs_history, notice: 'Docs history was successfully created.' }
        format.json { render :show, status: :created, location: @docs_history }
      else
        format.html { render :new }
        format.json { render json: @docs_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /docs_histories/1
  # PATCH/PUT /docs_histories/1.json
  def update
    respond_to do |format|
      if @docs_history.update(docs_history_params)
        format.html { redirect_to @docs_history, notice: 'Docs history was successfully updated.' }
        format.json { render :show, status: :ok, location: @docs_history }
      else
        format.html { render :edit }
        format.json { render json: @docs_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /docs_histories/1
  # DELETE /docs_histories/1.json
  def destroy
    @docs_history.destroy
    respond_to do |format|
      format.html { redirect_to docs_histories_url, notice: 'Docs history was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_docs_history
      @docs_history = DocsHistory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def docs_history_params
      params.require(:docs_history).permit(:docs_id, :description, :prev_histroy_id, :next_histroy_id, :by_user_id, :by_user_email)
    end
end
