module FlightsHelper
  def general_selector(form:, array:, field_name:, type:, current_value: {})
    current_value ||= {}
    form.select "#{field_name}[#{type}]",
                options_for_select(
                  array[type].uniq.sort || [],
                  selected: current_value && current_value[type]
                ),
                { include_blank: type.to_s.capitalize, selected: current_value[type] },
                { onchange: 'this.form.requestSubmit()' }
  end

  def date_select_fields(**kwargs)
    content_tag :div, class: 'date-select' do
      %i[year month day].map do |type|
        general_selector(type:, **kwargs)
      end.join.html_safe # rubocop:disable Rails/OutputSafety
    end
  end
end
