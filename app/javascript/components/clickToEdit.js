const clickToEdit = () => {
  let toEdit = document.getElementById("to-edit")
  if (toEdit) {
    toEdit.addEventListener('click', function (e) {
      console.log("coucoucouoc")           // journalise le className de mon_element
    })
  }
}

export { clickToEdit };
