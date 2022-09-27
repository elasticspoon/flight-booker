module FlightsHelper
  def date_injecter(values: [], selected: nil)
    <<~DOCSTRING
      document.addEventListener("DOMContentLoaded", function () {
        flatpickr("#depart-picker", {
          dateFormat: "m/d/Y",
          minDate: "today",
          defaultDate: "#{selected}",
          enable: #{values},
          inline: true,
        });
      });
    DOCSTRING
  end
end
