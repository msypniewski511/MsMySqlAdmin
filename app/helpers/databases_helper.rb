module DatabasesHelper

  # helper to get server attributes in string format!
  def get_info(object)
  	@return_var
    object.each do |element|
      @return_var = element.values[0].to_s
    end
    @return_var
  end
end
