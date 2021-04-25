const autoFillPriceBasket = () => {
  const array1 = [...Array(1000).keys()];
  array1.forEach(element => {

    if (document.querySelector(`#basket_line_quantity${element}`)) {
      const getQuantity = document.querySelector(`#basket_line_quantity${element}`);
      const getPTTTC = document.querySelector(`#basket_line_ttc_total${element}`);
      const getPUTTC = document.querySelector(`#basket_line_ttc_unit_price${element}`);

      getQuantity.addEventListener('keyup', (event) => {
        const totalTTC = Math.round(((parseFloat(getPUTTC.value) * parseFloat(getQuantity.value)) + Number.EPSILON) * 100) / 100;
        console.log(totalTTC)
        getPTTTC.value = totalTTC;
      });

      getPUTTC.addEventListener('keyup', (event) => {
        const totalTTC = Math.round(((parseFloat(getPUTTC.value) * parseFloat(getQuantity.value)) + Number.EPSILON) * 100) / 100;
        console.log(totalTTC)
        getPTTTC.value = totalTTC;
      });

      getPTTTC.addEventListener('keyup', (event) => {
        const quantityToAdd = Math.round((parseFloat(getPTTTC.value) / parseFloat(getPUTTC.value)) * 100) / 100;
        getQuantity.value = quantityToAdd;
      });
    };
  });

};

export { autoFillPriceBasket } ;

