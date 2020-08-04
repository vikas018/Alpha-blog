class ArticlesController < ApplicationController

    before_action :require_user, except: [:show , :index]
    before_action :require_same_user, only: [:edit, :update, :destroy]
    def show
       @article = Article.find(params[:id])
    end

    def index
        @articles = Article.paginate(page: params[:page], per_page: 5)
    end

    def new
        @article = Article.new
    end

    def edit
        @article = Article.find(params[:id])
    end

    def create
        @article = Article.new(params.require(:article).permit(:title, :description))
        @article.user = current_user
        if @article.save
            flash[:notice] = "Article was created successfully."
            # redirect_to action: "show", id: @article
            # redirect_to @article = Article.find(params[:id])
            # redirect_to @article
            redirect_to article_path(@article)
        else
            render 'new'
        end
    end

    def update
        @article = Article.find(params[:id])
        if @article.update(params.require(:article).permit(:title, :description))
            flash[:notice] = "Article was updated successfully"
            redirect_to @article
        else
            render 'edit'
        end
    end

    def destroy
        @article = Article.find(params[:id])
        @article.destroy
        redirect_to action: "index"
    end

    private
    def require_same_user
        @article = Article.find(params[:id])
        if current_user != @article.user
            flash[:alert] = "You can only edit or delete your own article"
            redirect_to @article
        end
    end
end