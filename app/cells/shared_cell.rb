class SharedCell < Cell::Rails

  def header
    @current_user = @opts[:current_user]

    render
  end

  def footer
    render
  end

  def admin_panel
    render
  end

  def nav_menu
    render
  end

  def application
    render
  end
end
