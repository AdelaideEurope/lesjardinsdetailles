import flatpickr from "flatpickr";
import "flatpickr/dist/themes/material_green.css";
import { French } from 'flatpickr/dist/l10n/fr.js';
const initFlatPickr = () => {
  flatpickr(".datepicker", {
    locale: French,
    altFormat: 'd M Y à H:i',
    enableTime: true,
    altInput: true,
    mode: "multiple",
  });

  flatpickr(".datepickerweek", {
    locale: French,
    altFormat: 'd M Y',
    altInput: true,
    weekNumbers: true,
  });

  flatpickr(".timepicker", {
    locale: French,
    altFormat: 'd M Y',
    altInput: true,
    enableTime: true,
    noCalendar: true,
    dateFormat: "H:i",
    time_24hr: true,
    mode: "multiple",
  });
};

export { initFlatPickr };
