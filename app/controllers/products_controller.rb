class ProductsController < ApplicationController
  
  def index
    @product = Product.all
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def create
    @product = Product.new(product_params)

    if @product.save
       @product.categories << Category.find(params[:product][:category_ids])
      redirect_to products_path
    else
      @errors = @product.errors.full_messages
      render 'products/new'
    end
  end


  def edit
    begin
      @product = Product.find(params[:id])
      @categories = Category.all
    rescue ActiveRecordNotFound
      redirect_to(products_path)
    end
  end


  def update
    params[:product][:category_ids] ||= []
    @product = Product.find(params[:id])
    if @product.update(product_params)
      @product.categories.destroy_all
      @product.categories << Category.find(params[:product][:category_ids])
      redirect_to(products_path)
    else
      render 'products/edit'
    end
  end

  def destroy
    @product = Product.destroy(params[:id])
    redirect_to(products_path)
  end


  protected
    def product_params
      params.require(:product).permit(:name, :price)
    end
end








