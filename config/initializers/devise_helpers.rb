# Override original devise helper methods here
module DeviseHelpers
  extend ActiveSupport::Concern

end

#ApplicationController.send :include, DeviseHelpers