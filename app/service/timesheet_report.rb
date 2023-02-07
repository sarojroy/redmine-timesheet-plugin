class TimesheetReport
  def initialize(last_day_of_month)
    @last_day_of_month = last_day_of_month
    @projects = {}
    @tasks = {}
    @total_by_date = {}
    @total_by_task_id = {}
    @total_hours = 0
    @data_by_date_and_task_id = {}
    @dates = []
    for i in 1..@last_day_of_month.day do
      @dates.append(@last_day_of_month.year.to_s + '-' + format('%02d', @last_day_of_month.month) + '-' + format('%02d', i));
    end
  end

  def get_dates()
    return @dates
  end

  def get_projects()
    return @projects
  end

  def get_tasks(projectId)
    return @tasks[projectId]
  end

  def get_total_by_task_id(taskId)
    return @total_by_task_id[taskId];
  end

  def get_work_hours_by_date_and_task(date, taskId)
    return @data_by_date_and_task_id[date + taskId.to_s];
  end

  def get_total_by_date(date)
    if (@total_by_date.has_key?(date))
      return @total_by_date[date]
    end
    return 0
  end

  def get_total_hours
    return @total_hours
  end

  def is_weekend(date)
    date = Date.parse(date)
    if date.friday? || date.saturday?
      return true
    end
    return false
  end

  def add_work_log_summary(task_id, task_title, project_id, project_title, spent_on_date, total_hours)

    if (!@projects.has_key?(project_id))
      @projects[project_id] = project_title
    end

    if (!@tasks.has_key?(project_id))
      @tasks[project_id] = {}
    end
    @tasks[project_id].store(task_id, task_title)

    formatted_date = spent_on_date.strftime('%Y-%m-%d')
    if (@data_by_date_and_task_id.has_key?(formatted_date + task_id.to_s))
      @data_by_date_and_task_id[formatted_date + task_id.to_s] = @data_by_date_and_task_id[formatted_date + task_id.to_s] + total_hours
    else
      @data_by_date_and_task_id[formatted_date + task_id.to_s] = total_hours
    end

    # Calculate total by spent_on_date
    if (@total_by_date.has_key?(formatted_date))
      @total_by_date[formatted_date] += total_hours
    else
      @total_by_date[formatted_date] = total_hours
    end

    # Calculate total by task
    if (@total_by_task_id.has_key?(task_id))
      @total_by_task_id[task_id] += total_hours
    else
      @total_by_task_id[task_id] = total_hours
    end

    # Calculate grand total
    @total_hours += total_hours
  end
end