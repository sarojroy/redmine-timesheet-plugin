Redmine::Plugin.register :timesheet do
  name 'Timesheet plugin'
  author 'Saroj Roy'
  description 'This is a timesheet plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/sarojroy/timesheet'
  author_url 'http://sarojroy.com'
  menu :application_menu, :bits_timesheet, { controller: 'timesheet', action: 'index' }, caption: 'Timesheet'
end
