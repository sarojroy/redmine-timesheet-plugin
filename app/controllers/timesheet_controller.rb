class TimesheetController < ApplicationController
  def index
    @requested_user_id = params[:user_id].blank? ? User.current.id.to_s : params[:user_id]
    @requested_user = User.find(@requested_user_id)
    @requested_month = params[:month].blank? ? Date.today.strftime("%m") : params[:month]
    @requested_year = params[:year].blank? ? Date.today.strftime("%Y") : params[:year]
    @last_day_of_month = Date.new(@requested_year.to_i, @requested_month.to_i, 1).next_month.prev_day
    @data = TimeEntry.where('user_id =? AND spent_on BETWEEN ? AND ?', @requested_user_id, @requested_year + '-' + @requested_month + '-01', @requested_year + '-' + @requested_month + '-' + @last_day_of_month.day.to_s);
    @users = User.where(status: 1).order('firstname').all()
    @timesheet_report = TimesheetReport.new(@last_day_of_month)
    @data.each do |worklog|
      issue_title = worklog.issue.blank? ? '' : worklog.issue.subject
      @timesheet_report.add_work_log_summary(worklog.issue_id, issue_title, worklog.project_id, worklog.project.name, worklog.spent_on, worklog.hours)
    end

  end
end

