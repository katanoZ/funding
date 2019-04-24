class Administrator::CategoriesController < Administrator::BaseController
  before_action :set_category, only: %i[show edit update destroy]

  def index
    @categories = Category.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to administrator_categories_path, notice: "カテゴリ「#{@category.name}」を作成しました"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to administrator_category_path(@category), notice: "カテゴリ「#{@category.name}」を更新しました"
    else
      render :edit
    end
  end

  def destroy
    @category.destroy!
    redirect_to administrator_categories_path, notice: "カテゴリ「#{@category.name}」を削除しました"
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
