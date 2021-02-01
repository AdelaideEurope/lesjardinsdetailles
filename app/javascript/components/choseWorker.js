const choseWorker = () => {
  const workers = document.querySelectorAll('.chose-worker');
  const workerLists = document.querySelectorAll('.event_worker_list')
  workers.forEach((worker) => {
    worker.addEventListener('click', (event) => {
      worker.classList.toggle("selected")
      worker.classList.toggle(event.currentTarget.dataset.workerColor)
      worker.classList.toggle("lightgrey")
      workerLists.forEach(workerList => {
        workerList.value += event.currentTarget.dataset.worker;
        workerList.value += ",";
      })
    });
  });
};



export { choseWorker };
