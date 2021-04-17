import flatpickr from "flatpickr";
import "flatpickr/dist/themes/material_green.css";
import { French } from 'flatpickr/dist/l10n/fr.js';
const initFlatPickr = () => {
  const saleDateInput = document.getElementById('sale_date')
  let saleDate = ""
  if (saleDateInput) {
    saleDate = saleDateInput.value
  } else {
    saleDate = ""
  }

  flatpickr(".datepicker", {
    locale: French,
    altFormat: 'd M Y à H:i',
    enableTime: true,
    altInput: true,
    mode: "multiple",
  });

  flatpickr(".datepickernotime", {
    locale: French,
    altFormat: 'd M Y',
    altInput: true,
    defaultDate: saleDate,
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
