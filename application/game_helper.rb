# frozen_string_literal: true

module GameHelper
  LAYOUT_PATH = File.expand_path('view/layouts/layout.html.erb', __dir__)

  def session_contain?(request, key)
    request.session.key?(key)
  end

  def redirect_to(page)
    Rack::Response.new { |response| response.redirect(page) }
  end

  def show_page(template)
    Rack::Response.new(render_layout { render_page_file(template) })
  end

  def partial(template)
    render_page_file(template)
  end

  private

  def render_layout
    ERB.new(File.read(LAYOUT_PATH)).result(binding)
  end

  def render_page_file(template)
    path = File.expand_path("view/#{template}.html.erb", __dir__)
    ERB.new(File.read(path)).result(binding)
  end
end
