require_dependency "free_pbx/application_controller"

module FreePbx
  class CdrsController < ApplicationController
    # respond_with, see:
    # http://archives.ryandaigle.com/articles/2009/8/6/what-s-new-in-edge-rails-cleaner-restful-controllers-w-respond_with
    respond_to :html, :xls, :json

    # 
    # Plays back an audio recording from AsteriskMonitor
    # Ignores the id param and uses the uniqueid param to find the file
    #
    def show
      monitor = AsteriskMonitor.find params[:uniqueid]
      if monitor and File.exists? monitor.path
        Rails.logger.debug "Streaming #{monitor.path}"
        send_file monitor.path, type: 'audio/x-wav', disposition: 'inline'
      else
        Rails.logger.warn "File not found with uniqueid #{params[:uniqueid]}"
        redirect_to action: :index, format: :html
      end
    end


    def index

      # 1) Setup Parameters: coerce params[:q] for any link that was clicked
      # If params[:day] is not nil, first check if it is set to magic values 'today' or 'yesterday'
      # If so, then convert it into a date to represent the magic value in format 'YYYY-MM-DD'
      # Then, pass to AsteriskCdr to get a ransack compatible query back
      #
      if params[:day]
        if ['today', 'yesterday'].include? params[:day]
          params[:day] = (params[:day].eql?('today') ? 0 : 1).days.ago.strftime('%Y-%m-%d')
        end
        params[:q] = AsteriskCdr.ransack_params_for(params[:day])
      end


      # 2) Search Object: generate a Ransack search object by processing params[:q]
      @search = AsteriskCdr.search(params[:q])
      @search.build_condition
      #Rails.logger.debug params[:q]
      #Rails.logger.debug "search returns #{@search.result.length}"
      #logger.debug request.format.to_s.eql? 'application/xls'

      # 3a) Render: If a tab was clicked, render JSON data using a custom class to return data in format for dataTable.js
      if params[:datatable]

        case params[:report]
        when 'cdrs'
          respond_with( CdrsDatatable.new(view_context, @search))
        when 'by_hour'
          respond_with( CdrsByHourDatatable.new(view_context, AsteriskCdr.calls_by_hour_and_agent(@search)) )
        when 'first_and_last'
          respond_with( CdrsFirstAndLastDatatable.new(view_context, AsteriskCdr.first_and_last(@search)) )
        when 'inbound'
          respond_with( CdrsInboundDatatable.new(view_context, AsteriskCdr.inbound_call_disposition(@search)) )
        end


      # 3b) Render: If a spreadsheet or email was requested, build the report objects necessary to render the XLS spreadsheet
      elsif request.format.to_s.eql? 'application/xls' or params[:email]

        @ast = AsteriskUser
        @cbh = AsteriskCdr.calls_by_hour @search
        @cbha = AsteriskCdr.calls_by_hour_and_agent @search
        @fnl =  AsteriskCdr.first_and_last @search
        @ibcd = AsteriskCdr.inbound_call_disposition @search

        if params[:email]
          report_date_range = params[:day] ? params[:day] : 'all'
          Rails.logger.info "Email of report for date #{report_date_range} requested"
          # TODO detele this value from application config
          #email_addresses = "#{APPLICATION_CONFIG['free_pbx']['call_report']['mail_to']}"
          # get a list of user objects .map(&:user) and from that array get just the email field .map(&:email)
#todo initializer of DryAuth can set it's table name, same as with CallCenter::Agent
# then can do a join
          #email_addresses = User.where(email_report: true).map(&:user).map(&:email)
          email_addresses = User.where(email_report: true).map(&:auth).map(&:email)
          data = render_to_string(format: :xls)
          #Rails.logger.debug data
          email_attachment = '/tmp/abc.xls'
          File.open(email_attachment, "w"){|f| f << data }
          ReportMailer.auto_email(email_addresses, email_attachment, report_date_range).deliver
          redirect_to action: :index, format: :html
        else
          respond_to {|format| format.xls}
        end


      # 3c) Render: Just render the HTML document
      else
        respond_with(@search)
      end

    end

  end
end

