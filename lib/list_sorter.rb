module ListSorter
  class MethodNotImplemented < Exception #:nodoc:
  end
  
  def self.included(base)    
    base.extend(ListSorter::ClassMethods)
  end
  
  module InstanceMethods
    # these get mixed-in as public instance methods, and can be accessed like any other action, provided that routes are made available (or the default routes are still in place)
    def list_sort
      collection_sort
      render :nothing => true
    end
    
    private
      def collection_sort
        list = current_list
        list.each do |item|
          item.position = params[self.class.list_sorter_index].index(item.id.to_s) + 1
          item.save
        end
      end
      
      # this method should be over-ridden
      def current_list
        raise ListSorter::MethodNotImplemented
      end
  end
  
  module ClassMethods
    # name serves as the params index from which the sort ids will be referenced
    # i.e. sort_list(:bios) will be used in params['bios'].index(item.id.to_s)
    def sorts_list(name)
      write_inheritable_attribute :list_sorter_index, name.to_s
      include ListSorter::InstanceMethods
    end
    
    def list_sorter_index
      read_inheritable_attribute :list_sorter_index
    end
  end
  
  module ViewHelpers
    # These two methods get mixed-in to ActionView::Base
    
    # put this in <head />
    def list_sorter_includes
      javascript_include_tag 'prototype', 'effects', 'dragdrop'
    end
    
    # 
    # Calls the sortable_element method to create a new Scriptaculous Sortable object.
    # 
    # Params
    # ======
    # <tt>id</tt> - The dom id of the containing element (usually a <ul>)
    # <tt>url</tt> - The url to the sort action
    # 
    # Options
    # =======
    # <tt>:complete</tt> - You may pass in an effect other than :highlight, which is the default. Keep in mind, this will be passed to the sortable_element method.
    def list_sortable_element(id, url, opts = {})
      opts[:complete] ||= visual_effect(:highlight, id)
      sortable_element(id, :url => url, :complete => opts[:complete])
    end
  end
  
  # This uses the method described in recipe 5 of "Rails Recipes"
  # 
  # options
  # parent is an instance of the parent model
  # children is a symbol of the collection to be sorted
  # def collection_sort(params)
  #   options = {}
  #   parent = eval(params[:parent].camelcase).find(params[:id])
  #   options[:index] = params[:index] || params[:children].to_s
  #    
  #   parent.send(params[:children]).each do |child|
  #     child.position = params["#{options[:index]}"].index(child.id.to_s) + 1
  #     child.save
  #   end
  # end
  # 
  # def normal_sort(collection = nil, options = {})
  #   collection ||= eval(params[:parent].classify).find(:all)
  #   options[:index] ||= collection[0].class.name.underscore.downcase.pluralize
  #   collection.each do |child|
  #     child.position = params["#{options[:index]}"].index(child.id.to_s) + 1
  #     child.save
  #   end
  # end
end