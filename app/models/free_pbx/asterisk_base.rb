
module FreePbx
  class AsteriskBase < ActiveRecord::Base
    self.abstract_class = true
    establish_connection "asterisk_#{Rails.env}"
  end
end

