const flipCard = () => {
  let cards = document.getElementsByClassName('flippable-card');

  // Loop through all the card elements
  Array.from(cards).forEach((card) => {

     // Track the clicks on the card element
     card.addEventListener('click', () => {

      // Toggle the `flippedstate` CSS class
      card.classList.toggle('card--flipped');
      console.log("Card clicked!");
    });
  });
};

export { flipCard } ;
