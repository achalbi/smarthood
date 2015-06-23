module ApplicationHelper

# Returns the full title on a per-page basis.       # Documentation comment
  def full_title(page_title)                          # Method definition
    base_title = "Smarthood"			 			  # Variable assignment
    if page_title.empty?                              # Boolean test
      base_title                                      # Implicit return
    else
      "#{base_title} | #{page_title}"                 # String interpolation
    end
  end

   def sortable(column, sort, direction, title = nil)  
    title ||= column.titleize  
    css_class = (column == sort_column(sort)) ? "current #{sort_direction(direction)}" : nil  
    direction = (column == sort_column(sort) && sort_direction(direction) == "asc") ? "desc" : "asc"  
	link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}  
  end  

end
