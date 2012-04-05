class ProductsController < ApplicationController
  
  before_filter :login_required
  before_filter :pre_load
  
  def pre_load
    @product = Product.find(params[:id]) if params[:id]
  end
  
  def new
    @product = Product.new
  end
  
  def create
    @product = Product.new(params[:product])
    if @product.save
      return redirect_to '/'
    end
    flash[:error] = @product.errors.to_json
    redirect_to '/products/new'
  end
  
  def show
    @streams = @product.streams
  end
  
  def edit
  end

  def update
    if @product.update_attributes(params[:product])
      redirect_to '/', :notice => '产品信息被修改了'
    else
      render :text=>@product.errors.to_json
    end
  end
  
end
