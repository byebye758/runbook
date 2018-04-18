module Factory
  def build(type, overrides={})
    case type
    when :book
      attrs = {
        title: "My Title",
      }.merge!(overrides)
      return Runbook::Entities::Book.new(attrs[:title])
    when :section
      attrs = {
        title: "My Title",
      }.merge!(overrides)
      return Runbook::Entities::Section.new(attrs[:title])
    when :step
      attrs = {
        title: "My Title",
      }.merge!(overrides)
      return Runbook::Entities::Step.new(attrs[:title])
    when :ask
      attrs = {
        prompt: "Continue?",
        into: :should_continue,
      }.merge!(overrides)
      return Runbook::Statements::Ask.new(
        attrs[:prompt],
        into: attrs[:into]
      )
    when :assert
      attrs = {
        cmd: "echo 'hi'",
        interval: 1,
        timeout: 0,
        exec_on_timeout: nil,
      }.merge!(overrides)
      return Runbook::Statements::Assert.new(
        attrs[:cmd],
        interval: attrs[:interval],
        timeout: attrs[:timeout],
        exec_on_timeout: attrs[:exec_on_timeout],
      )
    when :command
      attrs = {
        cmd: "echo 'hi'",
      }.merge!(overrides)
      return Runbook::Statements::Command.new(
        attrs[:cmd],
      )
    when :condition
      predicate = -> { true }
      if_stmt = -> { }
      attrs = {
        predicate: predicate,
        if_stmt: if_stmt,
        else_stmt: nil,
      }.merge!(overrides)
      return Runbook::Statements::Condition.new(
        predicate: attrs[:predicate],
        if_stmt: attrs[:if_stmt],
        else_stmt: attrs[:else_stmt],
      )
    when :confirm
      attrs = {
        prompt: "Continue?",
      }.merge!(overrides)
      return Runbook::Statements::Confirm.new(
        attrs[:prompt],
      )
    when :description
      attrs = {
        msg: "This is a loooong description",
      }.merge!(overrides)
      return Runbook::Statements::Description.new(
        attrs[:msg],
      )
    when :monitor
      attrs = {
        cmd: "ps aux | grep redis",
        prompt: "Redis is no longer running",
      }.merge!(overrides)
      return Runbook::Statements::Monitor.new(
        cmd: attrs[:cmd],
        prompt: attrs[:cmd],
      )
    when :note
      attrs = {
        msg: "fyi",
      }.merge!(overrides)
      return Runbook::Statements::Note.new(
        attrs[:msg],
      )
    when :notice
      attrs = {
        msg: "There be dragons!",
      }.merge!(overrides)
      return Runbook::Statements::Notice.new(
        attrs[:msg],
      )
    when :wait
      attrs = {
        time: 120,
      }.merge!(overrides)
      return Runbook::Statements::Wait.new(
        attrs[:time],
      )
    else
      raise "No factory found for #{type}!"
    end
  end
end
