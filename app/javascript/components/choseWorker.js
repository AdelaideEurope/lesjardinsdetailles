const choseWorker = () => {
  const workers = document.querySelectorAll('.chose-worker');
  const workerList = document.getElementById('event_worker_list')
  workers.forEach((worker) => {
    worker.addEventListener('click', (event) => {
      workerList.value += event.currentTarget.dataset.worker;
      workerList.value += ",";
      worker.classList.toggle("selected")
      worker.classList.toggle(event.currentTarget.dataset.workerColor)
      worker.classList.toggle("lightgrey")
    });
  });
};



export { choseWorker };
