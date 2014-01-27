module FreePbx
  class CdrsDatatable
    #delegate :params, :h, :link_to, :edit_cdr_path, to: :@view
    delegate :params, :h, :link_to, :cdr_path, to: :@view
  
    def initialize(view, search)
      @view = view
      @search = search
    end
  
    def as_json(options = {})
      {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: AsteriskCdr.count,
        iTotalDisplayRecords: cdrs.total_entries,
        aaData: data
      }
    end
  
  private
  
    def data
      cdrs.map do |cdr|
        [
          h(cdr.src),
          h(cdr.dst),
          h(cdr.calldate),
          h(cdr.disposition),
          h(cdr.duration),
          h(cdr.billsec),
          h(cdr.accountcode),
          # If there is a linked monitor then display a link to it
          cdr.asterisk_monitor_path.nil? ? '' : link_to('Recording', cdr_path(1, uniqueid: cdr.asterisk_monitor_uniqueid))
        ]
      end
    end
  
    def cdrs
      @cdrs ||= fetch_cdrs
    end
  
    def fetch_cdrs
      cdrs = @search.result
      #Rails.logger.debug "datatable search returns #{cdrs.length}"
      #cdrs = AsteriskCdr.order("#{sort_column} #{sort_direction}")
      cdrs = cdrs.page(page).per_page(per_page)
      #if params[:sSearch].present?
      #  cdrs = cdrs.data_search(params[:sSearch])
      #end
      cdrs
    end
  
    def page
      params[:iDisplayStart].to_i/per_page + 1
    end
  
    def per_page
      params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    end
  
    def sort_column
      columns = %w[src dst]
      columns[params[:iSortCol_0].to_i]
    end
  
    def sort_direction
      params[:sSortDir_0] == "desc" ? "desc" : "asc"
    end
  end

end

