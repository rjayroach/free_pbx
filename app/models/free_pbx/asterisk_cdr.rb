

module FreePbx
  class AsteriskCdr < ActiveRecord::Base
    db_base = "asteriskcdrdb"
    establish_connection "#{db_base}_#{Rails.env}"
    db_suffix = (['development', 'test'].include? Rails.env) ? "_#{Rails.env}" : ''
    self.table_name = "#{db_base}#{db_suffix}.cdr"

    self.primary_key = 'uniqueid'

    attr_accessible :calldate, :src, :dst, :disposition, :uniqueid


    # Associations
    has_one :asterisk_monitor, :primary_key => 'uniqueid', :foreign_key => 'uniqueid'
    delegate :path, :uniqueid, to: :asterisk_monitor, prefix: true, allow_nil: true

    # user_in maps the destination field to the extension of the user model to link inbound calls to users
    belongs_to :asterisk_user_in, :primary_key => 'extension', :foreign_key => 'dst', :class_name => 'AsteriskUser'
    belongs_to :asterisk_user_out, :primary_key => 'outboundcid', :foreign_key => 'src', :class_name => 'AsteriskUser'


    def self.joins_asterisk_users_by_src
      users_db = AsteriskUser.connection_config[:database].to_s
      joins( "inner join #{users_db}.users u ON src = u.extension OR src = u.outboundcid" )
    end


    def self.ransackable_attributes(auth_object = nil)
      %w( src dst disposition ) + _ransackers.keys
    end

    ransacker :calldate do
      Arel::Nodes::SqlLiteral.new("date(#{self.table_name}.calldate)")
    end


    # 
    # Return summary of calls placed by hour
    #
    def self.calls_by_hour search
      search.result.joins_asterisk_users_by_src.group_by_hour
    end


    # 
    # Return summary of calls placed by hour grouped by agent
    #
    def self.calls_by_hour_and_agent search
      search.result.joins_asterisk_users_by_src.group_by_src_and_hour
    end


    # 
    # Return Inbound Calls by Disposition for each user
    #
    def self.inbound_call_disposition search
      search.result.joins(:asterisk_user_in).select('name, dst, disposition, count(*) as total_calls').group('dst,disposition')
    end


    # 
    # Return first and last calls for each user
    #
    def self.first_and_last search
      min = search.result.joins_asterisk_users_by_src.group('u.extension').minimum('calldate')
      max = search.result.joins_asterisk_users_by_src.group('u.extension').maximum('calldate')
      min.zip(max)
    end


    # 
    # Calculate results based on hour and group by user
    #
    def self.group_by_src_and_hour
      self.group_by_hour 'src, u.extension,', 'u.extension,'
    end


    # 
    # Calculate results based on hour
    #
    def self.group_by_hour( fields = '', group = '')
      self.select("#{fields} hour(calldate) as hour, sum(disposition = 'ANSWERED') as completed, sum(CASE WHEN disposition='ANSWERED' THEN duration ELSE 0 END) as total_duration, count(*) as total_calls").group("#{group} hour")
    end


    #
    # Given a date parameter in format YYYY-MM-DD or a symbol :today or :yesterday
    # Returns a hash in format used by Ransack to generate a search result
    #
    def self.ransack_params_for(day)
      day = (day.eql?(:today) ? 0 : 1).days.ago.strftime('%Y-%m-%d') if [:today, :yesterday].include? day
      {"c"=>{"0"=>{"a"=>{"0"=>{"name"=>"calldate"}}, "p"=>"gteq", "v"=>{"0"=>{"value"=>"#{day}"}}}, "1"=>{"a"=>{"0"=>{"name"=>"calldate"}}, "p"=>"lteq", "v"=>{"0"=>{"value"=>"#{day}"}}}, "2"=>{"a"=>{"0"=>{"name"=>""}}, "p"=>"eq", "v"=>{"0"=>{"value"=>""}}}}}
    end

    # ---------------------------------------------------


    def self.calls_to value
      where(:dst => value)
    end

    def self.calls_from value
      where(:src => value)
    end


    # Returns all calls for a specific user
    def self.all_calls value
      t = self.arel_table

      results = self.where(
        t[:src].eq(value).
        or(t[:dst].eq(value))
      )
    end

    # Scopes 
    scope :answered, where(:disposition => 'ANSWERED')
    scope :not_answered, where(:disposition => 'NO ANSWER')

    # mixin the module with class level methods
    #extend Shmawesome

    # return a filtered set for dataTables
    # TODO will put filter fields at top of form, so grab those rather than using the search on datatable
    # in jQuery call, remove the search field from datatable
    def self.data_search param
      Rails.logger.debug "from model #{param}"
      Rails.logger.debug "from model #{param[q]}"
      where('src = ?', param)
    end

    def self.placed_today
      self.placed_on Time.now.to_s.split[0]
    end

    def self.placed_yesterday
      self.placed_on Time.now.yesterday.to_s.split[0]
    end

    def call_time
      calldate.to_s.split[1]
    end

    def self.placed_on begin_date
      self.placed_between begin_date, begin_date
    end

    def self.placed_between begin_date, end_date
      where("calldate between ? and ?", begin_date, "#{end_date} 23:59:59")
    end

  end
end




