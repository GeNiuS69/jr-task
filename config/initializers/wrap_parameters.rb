# frozen_string_literal: true

ActiveSupport.on_load(:active_record) do
  self.include_root_in_json = false
end
