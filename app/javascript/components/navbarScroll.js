const initUpdateNavbarOnScroll = () => {
  const navbar = document.querySelector('.scrollable-page-header');
  if (navbar) {
    window.addEventListener('scroll', (event) => {
      if (window.scrollY >= 20) {
        navbar.classList.add('scrolled-page-header');
        navbar.classList.remove('non-scrolled-page-header');
      } else {
        navbar.classList.remove('scrolled-page-header');
        navbar.classList.add('non-scrolled-page-header');
      }
    });
  }
}

export { initUpdateNavbarOnScroll };
