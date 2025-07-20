class MarkdownRenderer
  def initialize
    renderer = Redcarpet::Render::HTML.new(
      with_toc_data: true, # adds IDs to headers for anchor links
      hard_wrap: true
    )

    @markdown = Redcarpet::Markdown.new(renderer, {
      autolink: true,
      tables: true,
      fenced_code_blocks: true,
      strikethrough: true,
      lax_spacing: true
    })
  end

  def render(text)
    @markdown.render(text).html_safe
  end
end
