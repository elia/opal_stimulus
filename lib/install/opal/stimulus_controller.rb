# backtick: true
require "opal"
require "native"

class StimulusController
  def self.inherited(subclass)
    ::Opal.bridge(subclass.stimulus_controller, subclass)
    `window.Stimulus.register(#{subclass.stimulus_name}, #{subclass.stimulus_controller})`
  end

  def self.stimulus_name
    @stimulus_name ||=
      name.gsub(/Controller$/, "").gsub(/([a-z])([A-Z])/, '\1-\2').downcase
  end

  def self.stimulus_controller
    return @stimulus_controller if @stimulus_controller
    @stimulus_controller =
      `(class extends window.OpalStimulusController { initialize() {}; connect() {} })`
  end

  def self.method_added(name)
    # %w[initialize connect].include? name.to_s and return

    `#{@stimulus_controller}.prototype[#{name}] = #{@stimulus_controller}.prototype['$'+#{name}]`
  end
end
