# Include hook code here
ActionController::Base.send(:include, ListSorter)
ActionView::Base.send(:include, ListSorter::ViewHelpers)