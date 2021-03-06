
require 'will_paginate/array'

module FreePbx
  class CdrsByHourDatatable
    delegate :params, :h, :link_to, to: :@view
  
    def initialize(view, search)
      @view = view
      @search = search
    end
  
    def as_json(options = {})
      {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: cdrs.total_entries,
        iTotalDisplayRecords: cdrs.total_entries,
        aaData: data
      }
    end
  
  private
  
    def data
      cdrs.map do |cdr|
        [
          h(cdr.src),
          h(cdr.src),
          h(cdr.hour),
          h(cdr.total_calls),
          h(cdr.completed),
          h((cdr.completed/cdr.total_calls).round(4)*100),
          h((cdr.total_duration/60).round(1)),
          h((cdr.total_duration/cdr.completed/60).round(2))
        ]
      end
    end
  
    def cdrs
      @cdrs ||= fetch_cdrs
    end
  
    def fetch_cdrs
      cdrs = @search
      cdrs = cdrs.paginate(:page => page, :per_page => per_page, :total_entries => cdrs.length)
      if params[:sSearch].present?
        cdrs = cdrs.data_search(params[:sSearch])
      end
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

