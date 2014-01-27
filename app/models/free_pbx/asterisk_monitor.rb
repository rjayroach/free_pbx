module FreePbx
  class AsteriskMonitor < ActiveRecord::Base
    PROCESS_RECORDS_SIZE = 500

    #establish_connection "asteriskcdrdb" #if Rails.env.eql? 'production'
    #self.table_name = 'asteriskcdrdb.monitors'

    # MySQL: create index unq on ast_monitors (uniqueid);
    self.primary_key = 'uniqueid'

    # Fix for Strong parameters
    attr_accessible :path, :uniqueid
  
    belongs_to :cdr, :class_name => "AsteriskCdr", :primary_key => 'uniqueid', :foreign_key => 'uniqueid'

    validates :path, :uniqueid, :presence => true


    # 
    # Return an Enumerator of files on the file system (recursive)
    #
    def self.file_list
      require 'find'
      dirs = [ '/var/spool/asterisk/monitor' ]
      #for dir in dirs
        Find.find(dirs)
      #end
    end
  

    #
    # Build an index of recordings based on files in the file system
    #
    def self.reindex
      Rails.logger.info "Begin reindex of monitors at #{Time.now}"
      records = Array.new
      create_time = Time.now
      self.delete_all
      self.file_list.each do |path|
        r = path.reverse  # "vaw.0041.9571713221-8341-TUO/rotinom/ksiretsa/loops/rav/"
        i = r.index('-')  # 19
        if not i.nil?
          uniqueid = r[4,i-4].reverse  # "1223171759.1400"
          records.push "('#{path}', '#{uniqueid}', '#{create_time}', '#{create_time}')"
          if records.size == PROCESS_RECORDS_SIZE
            self.insert records
            records = Array.new
          end
        end
      end
      self.insert(records) if records.size > 0 # If odd number of records exist then add them
      Rails.logger.info "Finished reindex of monitors at #{Time.now}"
    end


    # 
    # Execute a bulk SQL insert
    #
    def self.insert records
      # quotes around field names do not work with mysql
      #sql = "INSERT INTO #{self.table_name} ('path', 'uniqueid', 'created_at', 'updated_at') VALUES #{records.join(", ")}"
      sql = "INSERT INTO #{self.table_name} (path, uniqueid, created_at, updated_at) VALUES #{records.join(", ")}"
      ActiveRecord::Base.connection.execute sql
    end


  end
end


