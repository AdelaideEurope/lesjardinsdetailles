const dateForCalendarEvent = () => {
  const days = document.querySelectorAll('.event-day');
  if (days) {
    days.forEach((day) => {
      day.addEventListener('dblclick', (event) => {

        let date = event.currentTarget.dataset.date;

        let modal = day.parentElement.lastElementChild;
        modal.classList.toggle("d-block");
        modal.classList.toggle("show");

        let startTime = modal.getElementsByClassName('start-time')[0]
        startTime.value = date

        let modalBtn = modal.firstElementChild.firstElementChild.firstElementChild.lastElementChild
        console.log(modalBtn)
        modalBtn.addEventListener('click', (event) => {
          modal.classList.toggle("d-block");
          modal.classList.toggle("show");
        })
        // modal.addEventListener('click', (event) => {
        //   modal.classList.toggle("d-block");
        //   modal.classList.toggle("show");
        //   event.stopPropagation();
        // })
      });
    });
  }
};

export { dateForCalendarEvent };
