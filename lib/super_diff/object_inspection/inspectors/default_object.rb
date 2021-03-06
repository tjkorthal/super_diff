module SuperDiff
  module ObjectInspection
    module Inspectors
      class DefaultObject < Base
        def self.applies_to?(_value)
          true
        end

        protected

        def inspection_tree
          # rubocop:disable Metrics/BlockLength
          InspectionTree.new do
            when_empty do
              # rubocop:disable Style/SymbolProc
              add_text do |object|
                object.inspect
              end
              # rubocop:enable Style/SymbolProc
            end

            when_non_empty do
              when_singleline do
                add_text do |object|
                  object.inspect
                end
              end

              when_multiline do
                add_text do |object|
                  "#<%<class>s:0x%<id>x {" % {
                    class: object.class,
                    id: object.object_id * 2,
                  }
                end

                nested do |object|
                  add_break " "

                  insert_separated_list(
                    object.instance_variables.sort,
                    separator: ","
                  ) do |name|
                    add_text name.to_s
                    add_text "="
                    add_inspection_of object.instance_variable_get(name)
                  end
                end

                add_break

                add_text "}>"
              end
            end
          end
          # rubocop:enable Metrics/BlockLength
        end
      end
    end
  end
end
