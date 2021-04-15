const autoFillPriceBasket = () => {
    const getPUHT = document.getElementById('basket_line_ht_unit_price');
    const getPUTTC = document.getElementById('basket_line_ttc_unit_price');
    const getPTHT = document.getElementById('basket_line_ht_total');
    const getPTTTC = document.getElementById('basket_line_ttc_total');
    const getQuantite = document.getElementById('basket_line_quantity');

  if (getPUTTC) {
    getPUTTC.addEventListener('change', (event) => {
      const calculTVA = parseFloat(getPUTTC.value * 0.055);
      const totalTTC = Math.round(((parseFloat(getPUTTC.value) * parseFloat(getQuantite.value)) + Number.EPSILON) * 100) / 100;
      getPTTTC.value = totalTTC
    })

    getQuantite.addEventListener('change', (event) => {
      if (getPUTTC.value !== "") {
        const totalTTC = Math.round(((parseFloat(getPUTTC.value) * parseFloat(getQuantite.value)) + Number.EPSILON) * 100) / 100;
        getPTTTC.value = totalTTC
      } else if (getPUTTC.value === "") {
        const calculTVA = parseFloat(getPUHT.value * 0.055);
        const totalPUTTC = Math.round(((parseFloat(getPUHT.value) + calculTVA) + Number.EPSILON) * 100) / 100;
        const calculPUTTC = totalPUTTC
        getPUTTC.value = calculPUTTC;
        const totalHT = Math.round(((parseFloat(getQuantite.value) * parseFloat(getPUHT.value)) + Number.EPSILON) * 100) / 100;
        // getPTHT.value = totalHT;
        const totalTTC = Math.round(((totalHT * 1.055) + Number.EPSILON) * 100) / 100;
        getPTTTC.value = totalTTC;
      }
    })
  }

};

export { autoFillPriceBasket } ;

