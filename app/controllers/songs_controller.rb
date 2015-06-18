class SongsController < ApplicationController
  before_action :set_song, only: [:update, :destroy]
  layout "headline"

  # GET /songs
  # GET /songs.json
  def index
    @show_instance = ShowInstance.find(params[:show_instance_id])
    #@songs = Song.all.sort_by(&:at).reverse
    @songs = @show_instance.songs
  end

  # POST /songs
  # POST /songs.json
  def create
    @song = Song.new(song_params)
    @song.at = Time.zone.now
    @song.show_instance = ShowInstance.on_air

    respond_to do |format|
      if @song.save
        format.html { redirect_to controller: :playlist, action: :index }
        format.json { render :show, status: :created, location: @song }
      else
        format.html {
          flash[:alert] = @song.errors.full_messages
          session[:song] = @song
          redirect_to controller: :playlist, action: :index }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.json { respond_with_bip @song }
      else
        format.json { respond_with_bip @song }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song.destroy
    respond_to do |format|
      format.html {
        flash[:alert] = ["Song deleted"]
        redirect_to controller: :playlist, action: :index
      }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def song_params
      params.require(:song).permit(:name, :artist, :request, :album, :label, :year)
    end
end
