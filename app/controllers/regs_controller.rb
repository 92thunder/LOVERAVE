class RegsController < ApplicationController
  before_action :set_reg, only: [:show, :edit, :update, :destroy]

  protect_from_forgery with: :null_session

  # GET /regs
  # GET /regs.json
  def index
    @regs = Reg.all
  end

  # GET /regs/1
  # GET /regs/1.json
  def show
  end

  # GET /regs/new
  def new
    @reg = Reg.new
  end

  # GET /regs/1/edit
  def edit
  end

  # POST /regs
  # POST /regs.json
  def create
    @reg = Reg.new(reg_params)

    respond_to do |format|
      if @reg.save
        format.html { redirect_to @reg, notice: 'Reg was successfully created.' }
        format.json { render action: 'show', status: :created, location: @reg }
      else
        format.html { render action: 'new' }
        format.json { render json: @reg.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /regs/1
  # PATCH/PUT /regs/1.json
  def update
    respond_to do |format|
      if @reg.update(reg_params)
        format.html { redirect_to @reg, notice: 'Reg was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @reg.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /regs/1
  # DELETE /regs/1.json
  def destroy
    @reg.destroy
    respond_to do |format|
      format.html { redirect_to regs_url }
      format.json { head :no_content }
    end
  end

  # 座標の近いやつが近くにいたらtrue
  # いなかったらfalseを返すアクション
  def near
    reg_id = params[:reg_id]
    x = params[:x]
    y = params[:y]

    # 端末IDがあれば更新する
    if Reg.exists?(:regid => reg_id) 
      @reg = Reg.find_by(regid: reg_id)
      @reg.x = x;
      @reg.y = y;
      @reg.update_columns(regid: reg_id, x: x, y: y)
    # 端末IDが無ければ作る。
    else 
      @reg = Reg.create(
        regid: reg_id,
        x: x,
        y: y
      )
    end
    
    @regs = Reg.all
    min = 100000
    # local
    x1 = @reg.x * Math::PI / 180
    y1 = @reg.y * Math::PI / 180
    @regs.each do |reg|
      if reg.id == @reg.id
        next
      end

      # models
      x2 = reg.x * Math::PI / 180
      y2 = reg.y * Math::PI / 180

      earth_r = 6371000
      deg = Math::sin(y1) * Math::sin(y2) + Math::cos(y1) * Math::cos(y2) * Math::cos(x2 - x1)
      distance = earth_r * (Math::atan(-deg / Math::sqrt(-deg * deg + 1)) + Math::PI / 2) / 1000
      if min > distance 
        min = distance
      end
    end
    # 10メートル以内だと1を返す
    if min < 10.0
      @result = true
    else
      @result = false
    end
    render :json => @result
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reg
      @reg = Reg.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reg_params
      params.require(:reg).permit(:regid, :x, :y)
    end
end
