
module FreePbx
  class AsteriskSip < AsteriskBase
    self.table_name = 'sip'
    belongs_to :asterisk_device, :foreign_key => 'id'

    attr_accessible :id, :keyword, :data, :flags
  end
end


