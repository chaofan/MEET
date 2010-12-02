class ActivityCell < Cell::Rails
  def minifeeds
    @activities = Activity.where("1=1").limit(5)
    logger.info(@activities)

    render
  end
end
