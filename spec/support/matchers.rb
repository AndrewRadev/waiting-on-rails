RSpec::Matchers.define :be_a_running_process do
  match_for_should do |pid|
    if pid.nil?
      false
    else
      begin
        Process.getpgid(pid)
        true
      rescue Errno::ESRCH
        false
      end
    end
  end

  match_for_should_not do |pid|
    if pid.nil?
      true
    else
      begin
        Process.getpgid(pid)
        false
      rescue Errno::ESRCH
        true
      end
    end
  end
end
