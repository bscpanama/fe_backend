require 'open-uri'
module V1
  class PdfsController < ApplicationController
    def show
      @document = Document.find(params[:id])
      result = PdfService.new(ActionController::Base.new.render_to_string('documents/show.html.erb', layout: false, locals: { data: @document}), "test.pdf").convert_from_html
      render json: { pdf: result.body['pdf'], status: :ok }
    end
  end
end
