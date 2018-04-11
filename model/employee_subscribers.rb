class CongratulateEmployeeSubscriber

  def is_subscribet_to?(event)
    event.class == SalaryHasChangedEvent
  end

  def handle(event)
    puts "Cogratulations #{event.employee.name}!!!!"
  end

end
