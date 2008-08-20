module ListSorter
  def self.included(base)
    base.class_eval do
      def list_sort
        collection_sort(params)
        render :nothing => true
      end
    end
  end
  
  # alias_method :active_sort, :collection_sort
  
  # use when the parent is not an active record object.
  # def normal_sort(params)
  #   params[:child].each do |item|
  #     item.position = params["#{options[:index]}"].index(item.id.to_s) + 1
  #   end
  # end
  
  
  
  # This uses the method described in recipe 5 of "Rails Recipes"
  # 
  # options
  # parent is an instance of the parent model
  # children is a symbol of the collection to be sorted
  def collection_sort(params)
    options = {}
    parent = eval(params[:parent].capitalize).find(params[:id])
    options[:index] = params[:index] || children.to_s
     
    parent.send(params[:children]).each do |child|
      child.position = params["#{options[:index]}"].index(child.id.to_s) + 1
      child.save
    end
  end
end