module ApplicationHelper
      # 
    # Render a Twitter Bootstrap compatible JS menu
    # See: http://railscasts.com/episodes/208-erb-blocks-in-rails-3
    #
    def mcp_button_group(opts = {}, &block)
      content = capture(&block) 
      content_tag(:div, class: "btn-group") do
        ( "<button id='#{opts[:name]}' class='btn #{opts[:class]}' data-toggle='#{opts[:toggle]}'>#{opts[:name]}</button>" +
          "<button class='btn dropdown-toggle #{opts[:class]}' data-toggle='dropdown'><span class='caret'></span></button>" +
          content_tag(:ul, content, class: "dropdown-menu")
        ).html_safe
      end
    end


        
=begin

        content_tag(:button, class: "btn #{opts[:class]}", data_toggle: "#{opts[:toggle]}") do
          (opts[:name] +
          content_tag(:button, class: "btn dropdown-toggle #{opts[:class]}", data_toggle: 'dropdown') {
            ("<span class='caret'></span></button>" + content_tag(:ul, content, class: "dropdown-menu")).html_safe
          }).html_safe
        end

<div class="btn-group">
    
  <ul class="dropdown-menu">
    <li><%= link_to "Today", cdrs_path(day: 'today')%></li>
    <li><%= link_to "Yesterday", cdrs_path(day: 'yesterday') %></li>
  </ul>
</div>

<div class="btn-group">
  <button id="exports" class="btn btn-primary" data-toggle="buttons-checkbox">Export</button>
  <button class="btn dropdown-toggle" data-toggle="dropdown"><span class="caret"></span></button>
    
  <ul class="dropdown-menu">
    <li><%= link_to "Excel", cdrs_path(format: "xls", :q => params[:q]) %></li>
  </ul>
</div>

<button id="email" class="btn btn-primary" type="button" data-url=<%= cdrs_path(format: "xls", q: params[:q]) %>>Large button</button>
=end

end
