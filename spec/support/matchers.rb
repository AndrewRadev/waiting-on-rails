RSpec::Matchers.define :be_a_running_process do
  match_for_should do |pid|
    return false if pid.nil?

    begin
      Process.getpgid(pid)
      true
    rescue Errno::ESRCH
      false
    end
  end

  match_for_should_not do |pid|
    begin
      Process.getpgid(pid)
      false
    rescue Errno::ESRCH
      true
    end
  end
end
