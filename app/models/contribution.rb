class Contribution
  include Mongoid::Document

  embedded_in :group
end

