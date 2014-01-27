module FreePbx
  class AsteriskUser < AsteriskBase
    db_base = "asterisk"
    db_suffix = (['development', 'test'].include? Rails.env) ? "_#{Rails.env}" : ''
    self.table_name = "#{db_base}#{db_suffix}.users"

    # NOTE 1: Setting primary_key in combination with strong_parameters in Rails 3 will throw
    # a mass-assignment error when attempting to manually assign the field value
    self.primary_key = 'extension'

    # NOTE 2: but we need a primary key to CRUD fields, so just make every attribute accessible
    attr_accessible :extension, :password, :name, :voicemail, :ringtimer, :noanswer
    attr_accessible :recording, :outboundcid, :sipname, :mohclass


    # See ElastixUser for explanation of keys
    # belongs_to :elastix_user, :primary_key => 'extension', :foreign_key => 'extension'

    # Mapping to device
    # TODO this is not completely flushed out
    has_one :asterisk_device, :primary_key => 'extension', :foreign_key => 'id'
  

    # All inbound calls have dst set to AU's extension in CDR records
    has_many :inbound_calls, class_name: "AsteriskCdr", primary_key: 'extension', foreign_key: 'dst'

    # Outbound calls will have src set in CDR recrods to AU's outboundcid if it is set in AU
    # otherwise the src is set to AU's extension, so two associations are necessary
    has_many :outbound_calls_by_extension, class_name: "AsteriskCdr", primary_key: 'extension', foreign_key: 'src'
    has_many :outbound_calls_by_cid, class_name: "AsteriskCdr", primary_key: 'outboundcid', foreign_key: 'src'


    #
    # Returns AsteriskUser's outbound calls
    # If outboundcid is defined then CDRs will have that value in 'src' field
    # otherwise they will have the extension number
    #
    def outbound_calls; outboundcid.empty? ? outbound_calls_by_extension : outbound_calls_by_cid end


    #
    # List the attributes available for filtering by Ransack
    #
    def self.ransackable_attributes(auth_object = nil)
      # super - %w( created_at updated_at parent_id )
      %w( extension name outboundcid ) + _ransackers.keys
    end


    # 
    # return the name of the user
    #
    def self.get_name_by_extension_or_outboundcid number_string
      name = 'unknown'
      r = self.find_by_extension_or_outboundcid number_string
      if !r.nil?
        # TODO this will try to get name from User
        name = r.name
      end
      name
    end

    #
    # Given a string, search for the AsteriskUser by extension or outboundcid
    #
    def self.find_by_extension_or_outboundcid number_string
      find_by_extension(number_string) || find_by_outboundcid(number_string)
    end


#    def all_calls
#      return AsteriskCdr.all_calls extension
#    end


=begin
    # NOTE: Only SIP device creation is currently supported
    before_create do |user|
      user.build_asterisk_device(:id => extension, :tech => 'sip', :dial => "SIP/#{extension}", :devicetype => 'fixed', :user => extension, :description => extension, :emergency_cid => '')
    end
=end


    # Delegates to the associated device, which uses its associated technology to initate a call
    def originate destination
      asterisk_device.originate destination
    end

  
  end
end


