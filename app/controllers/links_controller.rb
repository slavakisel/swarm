class LinksController < ApplicationController
  def index
    links = Link.processed.page(params[:page]).per(params[:per_page])

    render json: links
  end

  def create
    link = Link.new(link_params)

    if link.valid?
      IndexPageJob.perform_later(link.url)
      render json: { message: I18n.t('links.create.success') }
    else
      render json: { errors: link.errors }, status: 400
    end
  end

  private

  def link_params
    params.require(:link).permit(:url)
  end
end
