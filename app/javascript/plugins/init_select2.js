import $ from 'jquery';
import 'select2';

// function definitions
const initSelect2 = () => {
  $(document).ready(function() {
    $('#sales_line_product').select2({ placeholder: 'Produit' });
    $('#beds_').select2({multiple: true});
  });
};

// exports (~ public interface)
export { initSelect2 };
