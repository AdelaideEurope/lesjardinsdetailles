const autoFillPrice = () => {
    const getPUHT = document.getElementById('sales_line_ht_unit_price');
    const getPUTTC = document.getElementById('sales_line_ttc_unit_price');
    const getPTHT = document.getElementById('sales_line_ht_total');
    const getPTTTC = document.getElementById('sales_line_ttc_total');
    const getQuantite = document.getElementById('sales_line_quantity');

  if (getPUHT) {
    getPUHT.addEventListener('change', (event) => {
      const calculTVA = parseFloat(getPUHT.value * 0.055);
      const totalPUTTC = Math.round(((parseFloat(getPUHT.value) + calculTVA) + Number.EPSILON) * 100) / 100;
      const calculPUTTC = totalPUTTC
      getPUTTC.value = calculPUTTC;
      const totalHT = Math.round(((parseFloat(getPUHT.value) * parseFloat(getQuantite.value)) + Number.EPSILON) * 100) / 100;
      getPTHT.value = totalHT
      const totalTTC = Math.round(((totalHT * 1.055) + Number.EPSILON) * 100) / 100;
      getPTTTC.value = Math.round((totalTTC + Number.EPSILON) * 100) / 100
    })

    getPUTTC.addEventListener('change', (event) => {
      const calculTVA = parseFloat(getPUTTC.value * 0.055);
      // const totalPUHT = Math.round(((parseFloat(getPUTTC.value) - calculTVA) + Number.EPSILON) * 100) / 100;
      // const calculPUHT = totalPUHT
      getPUHT.value = calculPUHT;
      const totalTTC = Math.round(((parseFloat(getPUTTC.value) * parseFloat(getQuantite.value)) + Number.EPSILON) * 100) / 100;
      getPTTTC.value = totalTTC
      const totalHT = Math.round(((parseFloat(getPUHT.value) * parseFloat(getQuantite.value)) + Number.EPSILON) * 100) / 100;
      getPTHT.value = totalHT
    })

    getQuantite.addEventListener('change', (event) => {
      if (getPUHT.value !== "" && getPUTTC.value !== "") {
        const totalHT = Math.round(((parseFloat(getQuantite.value) * parseFloat(getPUHT.value)) + Number.EPSILON) * 100) / 100;
        getPTHT.value = totalHT;
        const totalTTC = Math.round(((totalHT * 1.055) + Number.EPSILON) * 100) / 100;
        getPTTTC.value = totalTTC;

      } else if (getPUHT.value !== "" && getPUTTC.value === "") {
        const calculTVA = parseFloat(getPUHT.value * 0.055);
        const totalPUTTC = Math.round(((parseFloat(getPUHT.value) + calculTVA) + Number.EPSILON) * 100) / 100;
        const calculPUTTC = totalPUTTC
        getPUTTC.value = calculPUTTC;
        const totalHT = Math.round(((parseFloat(getQuantite.value) * parseFloat(getPUHT.value)) + Number.EPSILON) * 100) / 100;
        getPTHT.value = totalHT;
        const totalTTC = Math.round(((totalHT * 1.055) + Number.EPSILON) * 100) / 100;
        getPTTTC.value = totalTTC;
      }
    })
  }

};

export { autoFillPrice } ;

