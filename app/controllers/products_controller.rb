class ProductsController < ApplicationController
  include ApplicationHelper

  def index
    @products = Product.all
  end

  def new
  end

  def create
    unless valid_url?(product_params[:product_url])
      redirect_to(new_product_path, alert: 'invalid walmart url') && return
    end

    @product = Walmart::WalmartProductCreateService.new(product_params[:product_url], product_params[:review_black_list]).create_or_update_product

    unless @product
      redirect_to(new_product_path, alert: 'product import failed, correct url and try again') && return
    end

    redirect_to product_path(@product)
  end

  def show
    @product = Product.includes(:reviews).find(product_params[:id])
  end

  private
  def product_params
    params.permit(:id, :product_url, :review_black_list)
  end
end