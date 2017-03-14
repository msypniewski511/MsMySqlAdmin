module ColumnsHelper
  def get_key_value(object)
  	parallel_value = []
  	object.each do |row|
  	  row.each do |key, value|
        parallel_value << value
      end
  	end
  	return parallel_value
  end
end
