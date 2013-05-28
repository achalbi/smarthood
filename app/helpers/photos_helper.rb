module PhotosHelper

  def defaultPhoto(module_name)
    if module_name = 'new_group'
      Photo.find('154')
    end
  end
 
end
