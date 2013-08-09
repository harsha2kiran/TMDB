object @report
attributes :id, :reportable_id, :reportable_type, :created_at, :updated_at
node(:reported_content){ |report| report.reportable_type.classify.constantize.find(report.reportable_id) }
