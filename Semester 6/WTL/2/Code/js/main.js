const changeUrl = (e) => {
  // e.preventDefault();
  document.getElementById('frame').src = e.target.href;
}


[...document.getElementsByClassName('site-info')].forEach(site => {
  site.addEventListener('click', changeUrl);
  [...site.children].forEach(child => {
    child.href = site.href;
  });
});


document.getElementById('form').addEventListener('submit', (e) => {
  if (document.getElementById('spamProtection').value !== '10') {
    e.preventDefault();
    alert('Please answer the spam protection question correctly.');
  }
});