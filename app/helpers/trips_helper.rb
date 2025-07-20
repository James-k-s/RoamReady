module TripsHelper
  def checklist_with_checkboxes(html)
    html.gsub(/<li>\[( |x)\] (.*?)<\/li>/i) do
      checked = $1.downcase == 'x'
      item = $2
      %Q(<li class="checklist-item"><label><input type="checkbox" disabled#{' checked' if checked}> #{item}</label></li>)
    end.html_safe
  end

end
