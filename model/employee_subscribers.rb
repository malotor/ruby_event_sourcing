class EmployeeSubscriber

  def is_subscribet_to?(event)
    raise StandardError "Method not implemented"
  end

  def handle(event)
    raise StandardError "Method not implemented"
  end
end

class CongratulateEmployeeSubscriber < EmployeeSubscriber

  def is_subscribet_to?(event)
    event.class == SalaryHasChangedEvent
  end

  def handle(event)
    puts "Cogratulations for your new salary => #{event.new_salary}!!!!"
  end

end
