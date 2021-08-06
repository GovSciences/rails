# frozen_string_literal: true

class CallbackDebugger

  STACK_DEPTH = 'stack_depth'

  def self.list_callbacks(clazz)
    puts "#{clazz.name}"
    clazz.__callbacks.each do |type, callbacks|
      puts "  #{type}" if callbacks.present?
      callbacks.each{ |callback| puts "    #{callback.kind}_#{type} - #{callback.filter}" }
    end
  end

  def self.stack_depth
    Thread.current[STACK_DEPTH] || 0
  end

  def self.reset_stack_depth
    Thread.current[STACK_DEPTH] = 0
  end

  def self.deeper
    Thread.current[STACK_DEPTH] = (stack_depth) + 1
  end

  def self.up
    Thread.current[STACK_DEPTH] = (Thread.current[STACK_DEPTH] || 1) - 1
  end

  def self.prefix
    stack_depth.times.map{'  '}.join
  end

  def self.log(s)
    puts "(#{stack_depth}) #{prefix}#{s}" if ENV['LOG_CALLBACKS']&.downcase == 'true'
  end

  def self.log_block(s)
    log(s)
    deeper
    return_val = yield
    up
    return return_val
  end
end
