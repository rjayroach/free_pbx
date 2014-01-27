
module FreePbx
  class ElastixUser < ActiveRecord::Base
    establish_connection "elastix_acl" if ['development', 'production'].include? Rails.env
    self.table_name = 'acl_user'

    attr_accessible :id, :name, :description, :md5_password, :extension

    # The relationship to AsteriskUser is based on the ElastiUser.extension and the AsteriskUser.extension
    # :primary_key indicates that the field in this model used to reference AsteriskUser is 'extension'
    # :foreign_key indicates that the field in the AsteriskUser model is also named 'extension'
    has_one :asterisk_user, :primary_key => 'extension', :foreign_key => 'extension'

    # For more delegate options, see: http://www.simonecarletti.com/blog/2009/12/inside-ruby-on-rails-delegate/
    delegate :all_calls, :to => :asterisk_user
    delegate :inbound_calls, :to => :asterisk_user
    delegate :outbound_calls, :to => :asterisk_user

    before_create do |eu|
      eu.build_asterisk_user(:extension => extension)
#FreePbx::AsteriskUser(extension: string, password: string, name: string, voicemail: string, ringtimer: integer, noanswer: string, recording: string, outboundcid: string, sipname: string, mohclass: string)
    end


    # NOTE: See about delegating
    def originate destination
      asterisk_user.originate destination
    end

    def password_match? pwd
      return md5_password.eql? Digest::MD5.hexdigest pwd
    end

    def self.sync_to_asterisk_users
      AsteriskUser.all.each do |ast_user|
        if not find_by_extension ast_user.extension
#          p "NOT found #{ast_user.extension}"
          password = Digest::MD5.hexdigest ast_user.extension
          create!(:name => ast_user.name, :extension => ast_user.extension, :md5_password => password, :description => 'auto')
#        else
#          p "found #{ast_user.extension}"
        end
      end
    end


  end
end


